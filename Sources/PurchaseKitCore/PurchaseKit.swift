//
//  PurchaseKit.swift
//  
//
//  Created by Anton Kormakov on 18.10.2023.
//

import Foundation
import UIKit

public final class PurchaseKit {
    public typealias Dependencies = PurchaseKitServiceFactory

    enum PurchaseKitError: Error {
        case timeout
        case invalidConfiguration
        case invalidModuleType(String)
        case pageModelMismatch(String)
        case premiumUser
    }

    public static var shared: PurchaseKit = .init()
    public private(set) var configuration: PurchaseKitConfiguration = .invalid
    public private(set) var dependencies: Dependencies!

    public var isPremiumLimitReached: Bool {
        guard dependencies.storeService.isAnySubscriptionActive == false else {
            return false
        }
        
        guard let limit = dependencies.remoteConfigService.remoteConfig.premiumEventTriggerLimit else {
            return false
        }

        return dependencies.userSettingsService.premiumEventTriggerCount >= limit
    }

    private lazy var paywallBuilder: PaywallBuilder = .init()
    private lazy var outputs: [String: PaywallModuleOutput] = [:]

    private init() {}

    public func start(with configuration: PurchaseKitConfiguration, dependencies: Dependencies) {
        self.configuration = configuration
        self.dependencies = dependencies

        dependencies.remoteConfigService.fetch(success: { _ in }, failure: { (error: Error) in
            self.handleRemoteConfigFetchFailure(error: error)
        })
    }

    public func register(_ moduleType: any PurchaseKitModule.Type) {
        paywallBuilder.register(moduleType)
    }

    public func preload(identifier: String) {
        performFetch(identifier: identifier, shouldWaitForProductFetch: true, success: { _ in }, failure: { _ in })
    }

    public func trackPremiumEvent() {
        dependencies.userSettingsService.premiumEventTriggerCount += 1
    }

    public func resetPremiumEventTracker() {
        dependencies.userSettingsService.premiumEventTriggerCount = 0
    }

    public func present(identifier: String,
                        on viewController: UIViewController,
                        bindings: PaywallBindings,
                        shouldWaitForProductFetch: Bool = true,
                        success: ((Paywall) -> Void)? = nil,
                        failure: ((Error) -> Void)? = nil) {
        guard dependencies.storeService.isAnySubscriptionActive == false else {
            DispatchQueue.main.async {
                failure?(PurchaseKitError.premiumUser)
            }
            return
        }

        fetch(identifier: identifier,
              shouldWaitForProductFetch: shouldWaitForProductFetch,
              success: { (paywall: Paywall) in
            self.present(paywall: paywall, on: viewController, output: bindings, success: success, failure: failure)
        }, failure: { (error: Error) in
            failure?(error)
        })
    }

    public func fetch(identifier: String,
                      shouldWaitForProductFetch: Bool = true,
                      success: @escaping ((Paywall) -> Void),
                      failure: @escaping ((Error) -> Void)) {
        guard configuration.isValid else {
            failure(PurchaseKitError.invalidConfiguration)
            return
        }

        let timer: Timer = .init(timeInterval: configuration.timeout, repeats: false) { (timer: Timer) in
            timer.invalidate()

            let error = PurchaseKitError.timeout
            self.handlePaywallFetchFailure(identifier: identifier, error: error)
            failure(error)
        }
        RunLoop.current.add(timer, forMode: .common)

        dependencies.remoteConfigService.fetch { (config: RemoteConfig) in
            guard timer.isValid else {
                return
            }

            let target = config.paywallIdentifierOverride ?? identifier
            self.performFetch(identifier: target,
                              shouldWaitForProductFetch: shouldWaitForProductFetch,
                              success: { (paywall: Paywall) in
                guard timer.isValid else {
                    return
                }

                timer.invalidate()
                success(paywall)
            }, failure: { (error: Error) in
                timer.invalidate()
                self.handlePaywallFetchFailure(identifier: target, error: error)
                failure(error)
            })
        } failure: { (error: Error) in
            timer.invalidate()
            let target = self.dependencies.remoteConfigService.remoteConfig.paywallIdentifierOverride ?? identifier
            self.handleRemoteConfigFetchFailure(error: error)
            self.performFetch(identifier: target,
                              shouldWaitForProductFetch: shouldWaitForProductFetch,
                              success: success,
                              failure: failure)
        }
    }

    private func performFetch(identifier: String,
                              shouldWaitForProductFetch: Bool,
                              success: @escaping ((Paywall) -> Void),
                              failure: @escaping ((Error) -> Void)) {
        dependencies.paywallService.fetch(identifier: identifier,
                                          builder: paywallBuilder,
                                          success: { (paywall: Paywall) in
            if shouldWaitForProductFetch == false {
                success(paywall)
            }

            self.dependencies.storeService.fetchProducts(for: paywall, success: { (products: [Product]) in
                guard shouldWaitForProductFetch else {
                    return
                }

                success(paywall)
            }, failure: { (error: Error) in
                self.dependencies.analyitcsService.log(.productFetchFailed(for: paywall, error: error))
                failure(error)
            })
        }, failure: { (error: Error) in
            failure(error)
        })
    }

    private func handlePaywallFetchFailure(identifier: String, error: Error) {
        dependencies.analyitcsService.log(.paywallFetchFailed(identifier: identifier, error: error))
    }

    private func handleRemoteConfigFetchFailure(error: Error) {
        let remoteConfigIdentifier = type(of: dependencies.remoteConfigService.remoteConfig).identifier
        dependencies.analyitcsService.log(.remoteConfigFetchFailed(identifier: remoteConfigIdentifier, error: error))
    }

    public func present(paywall: Paywall,
                        on viewController: UIViewController,
                        output: PaywallModuleOutput? = nil,
                        success: ((Paywall) -> Void)? = nil,
                        failure: ((Error) -> Void)? = nil) {
        var submodules: [any PurchaseKitModule] = []
        for page in paywall.pages {
            guard let moduleType = paywallBuilder.moduleTypes[page.type] else {
                let error = PurchaseKitError.invalidModuleType(page.type)
                dependencies.analyitcsService.log(.paywallDisplayFailed(identifier: paywall.identifier, error: error))
                failure?(error)
                return
            }

            guard let module = moduleType.makeModule(for: page, colorScheme: configuration.colorScheme, output: nil) else {
                let error = PurchaseKitError.pageModelMismatch(page.type)
                dependencies.analyitcsService.log(.paywallDisplayFailed(identifier: paywall.identifier, error: error))
                failure?(error)
                return
            }

            submodules.append(module)
        }

        let state = PaywallState(paywall: paywall, configuration: configuration, submodules: submodules)
        state.context = viewController

        let module = PaywallModule(state: state, dependencies: dependencies, output: self)
        for submodule in submodules {
            submodule.output = module.input
        }

        outputs[state.identifier] = output
        viewController.present(module.viewController, animated: true)
    }
}

// MARK: - PaywallModuleOutput

extension PurchaseKit: PaywallModuleOutput {
    public func paywallModuleDidRequestContent(_ sender: PaywallModuleInput, for page: any Page) -> UserContent? {
        return outputs[sender.state.identifier]?.paywallModuleDidRequestContent(sender, for: page)
    }

    public func paywallModuleDidPurchase(_ sender: PaywallModuleInput, product: Product) {
        outputs[sender.state.identifier]?.paywallModuleDidPurchase(sender, product: product)
    }

    public func paywallModuleDidFail(_ sender: PaywallModuleInput, with error: Error) {
        outputs[sender.state.identifier]?.paywallModuleDidFail(sender, with: error)
    }

    public func paywallModuleDidFinish(_ sender: PaywallModuleInput) {
        sender.state.context?.presentedViewController?.dismiss(animated: true)
        if let output = outputs.removeValue(forKey: sender.state.identifier) {
            dependencies.analyitcsService.log(.paywallDismissed(paywall: sender.state.paywall))
            output.paywallModuleDidFinish(sender)
        }
    }
}
