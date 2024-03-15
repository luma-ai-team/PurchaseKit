//
//  AdaptyService.swift
//  
//
//  Created by Anton Kormakov on 19.10.2023.
//

import Foundation
import PurchaseKitCore
import Adapty

public final class AdaptyService<Config: RemoteConfig>: PaywallService, StoreService, RemoteConfigService {
    enum AdaptyServiceError: Error {
        case noData
        case noRemoteConfig
        case unknownPaywall(String)
        case productMismatch(paywallIdentifier: String, productIdentifier: String)
    }

    final class PaywallRecord {
        let adaptyPaywall: AdaptyPaywall
        let purchaseKitPaywall: Paywall
        var products: [String: AdaptyPaywallProduct] = [:]

        init(adaptyPaywall: AdaptyPaywall, purchaseKitPaywall: Paywall) {
            self.adaptyPaywall = adaptyPaywall
            self.purchaseKitPaywall = purchaseKitPaywall
        }
    }

    public var isAnyProductPurchased: Bool {
        #if targetEnvironment(simulator)
        return shouldSimulateSubscribedState
        #endif

        return profile?.nonSubscriptions.keys.isEmpty == false
    }

    public var isAnySubscriptionActive: Bool {
        #if targetEnvironment(simulator)
        return shouldSimulateSubscribedState
        #endif

        return profile?.subscriptions.contains(where: { (key: String, value: AdaptyProfile.Subscription) in
            return value.isActive
        }) == true
    }

    public var remoteConfig: Config
    private var didFetchRemoteConfig: Bool = false

    public var analyticsProxy: AnalyticsService?

    private var profile: AdaptyProfile? {
        didSet {
            guard let profile = profile else {
                return
            }

            profileUpdateHandler?(profile)
        }
    }

    private var paywalls: [String: PaywallRecord] = [:]
    private var products: [AdaptyPaywallProduct] = []

    public var profileUpdateHandler: ((AdaptyProfile) -> Void)?

    #if targetEnvironment(simulator)
    private var shouldSimulateSubscribedState: Bool = false
    #endif

    init(key: String, userId: String? = nil, remoteConfigFallback: Config, configurator: ((Adapty.Type) -> Void)? = nil) {
        self.remoteConfig = remoteConfigFallback
        Adapty.activate(key, customerUserId: userId, { error in
            if let error = error {
                print("[EE] Error activating adapty: ", error.localizedDescription)
            }

            configurator?(Adapty.self)
        })
        Adapty.delegate = self
        Adapty.getProfile { [weak self] (result: AdaptyResult<AdaptyProfile>) in
            self?.profile = try? result.get()
        }
    }

// MARK: - RemoteConfigService

    public func fetch(success: @escaping (Config) -> Void, failure: @escaping (Error) -> Void) {
        if didFetchRemoteConfig {
            return success(remoteConfig)
        }

        Adapty.getPaywall(placementId: Config.identifier) { [weak self] (result: AdaptyResult<AdaptyPaywall>) in
            guard let self = self,
                  let jsonString = try? result.get().remoteConfigString,
                  let data = jsonString.data(using: .utf8) else {
                return failure(AdaptyServiceError.noRemoteConfig)
            }

            do {
                let decoder = JSONDecoder()
                self.remoteConfig = try decoder.decode(Config.self, from: data)
                self.didFetchRemoteConfig = true
                DispatchQueue.main.async {
                    success(self.remoteConfig)
                }
            }
            catch {
                DispatchQueue.main.async {
                    failure(error)
                }
            }
        }
    }

// MARK: - PaywallService

    public func fetch(identifier: String,
                      builder: PaywallBuilder,
                      success: @escaping (Paywall) -> Void,
                      failure: @escaping (Error) -> Void) {
        if let record = paywalls[identifier] {
            return success(record.purchaseKitPaywall)
        }

        Adapty.getPaywall(placementId: identifier) { [weak self] (result: AdaptyResult<AdaptyPaywall>) in
            guard let self = self else {
                return
            }

            do {
                let adaptyPaywall = try result.get()
                let paywall = try self.makePaywall(from: adaptyPaywall, using: builder)
                self.paywalls[identifier] = .init(adaptyPaywall: adaptyPaywall, purchaseKitPaywall: paywall)
                DispatchQueue.main.async {
                    success(paywall)
                }
            }
            catch {
                DispatchQueue.main.async {
                    failure(error)
                }
            }
        }
    }

    private func makePaywall(from adaptyPaywall: AdaptyPaywall, using builder: PaywallBuilder) throws -> Paywall {
        guard let jsonString = adaptyPaywall.remoteConfigString,
              let data = jsonString.data(using: .utf8) else {
            throw AdaptyServiceError.noData
        }

        return try builder.makePaywall(from: data, identifier: adaptyPaywall.placementId)
    }

// MARK: - StoreService

    public func fetchProducts(for paywall: Paywall, success: @escaping ([Product]) -> Void, failure: @escaping (Error) -> Void) {
        guard let record = paywalls[paywall.identifier] else {
            return failure(AdaptyServiceError.unknownPaywall(paywall.identifier))
        }

        Adapty.getPaywallProducts(paywall: record.adaptyPaywall) { (result: AdaptyResult<[AdaptyPaywallProduct]>) in
            do {
                let adaptyProducts = try result.get()

                var productMap: [String: AdaptyPaywallProduct] = [:]
                for adaptyProduct in adaptyProducts {
                    productMap[adaptyProduct.vendorProductId] = adaptyProduct
                }
                record.products = productMap

                let products = adaptyProducts.map { (product: AdaptyPaywallProduct) in
                    return Product(product: product.skProduct)
                }
                DispatchQueue.main.async {
                    success(products)
                }
            }
            catch {
                DispatchQueue.main.async {
                    failure(error)
                }
            }
        }
    }

    public func purchase(_ product: Product,
                         from paywall: Paywall,
                         success: @escaping (Product) -> Void,
                         failure: @escaping (Error) -> Void) {
        #if targetEnvironment(simulator)
        shouldSimulateSubscribedState = true
        DispatchQueue.main.async {
            success(product)
        }
        #endif

        guard let record = paywalls[paywall.identifier] else {
            return failure(AdaptyServiceError.unknownPaywall(paywall.identifier))
        }

        guard let adaptyProduct = record.products[product.identifier] else {
            return failure(AdaptyServiceError.productMismatch(paywallIdentifier: paywall.identifier,
                                                              productIdentifier: product.identifier))
        }

        Adapty.makePurchase(product: adaptyProduct) { [weak self] (result: AdaptyResult<AdaptyPurchasedInfo>) in
            guard let self = self else {
                return
            }

            switch result {
            case .success(let info):
                self.profile = info.profile
                DispatchQueue.main.async {
                    success(product)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    failure(error)
                }
            }
        }
    }

    public func restore(success: @escaping () -> Void, failure: @escaping (Error) -> Void) {
        Adapty.restorePurchases { (result: AdaptyResult<AdaptyProfile>) in
            switch result {
            case .success(let profile):
                self.profile = profile
                DispatchQueue.main.async {
                    success()
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    failure(error)
                }
            }
        }
    }
}

// MARK: - AnalyticsService

extension AdaptyService: AnalyticsService {
    public func log(_ event: AnalyticsEvent) {
        if event.identifier == AnalyticsEvent.EventIdentifier.paywallDisplayed.rawValue,
           let identifier = event.parameters[AnalyticsEvent.EventParameter.identifier.rawValue] {
            guard let adaptyPaywall = paywalls[identifier]?.adaptyPaywall else {
                return
            }

            Adapty.logShowPaywall(adaptyPaywall)
        }

        analyticsProxy?.log(event)
    }
}

// MARK: - AdaptyDelegate

extension AdaptyService: AdaptyDelegate {
    public func didLoadLatestProfile(_ profile: AdaptyProfile) {
        self.profile = profile
    }
}
