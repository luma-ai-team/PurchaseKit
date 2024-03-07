//
//  AdaptyServiceFactory.swift
//  
//
//  Created by Anton Kormakov on 25.10.2023.
//

import Foundation
import PurchaseKitCore
import Adapty

public final class AdaptyServiceFactory<Config: RemoteConfig>: PurchaseKitServiceFactory {
    public var paywallService: PaywallService {
        return adaptyService
    }

    public var remoteConfigService: any RemoteConfigService {
        return adaptyService
    }

    public var storeService: StoreService {
        return adaptyService
    }

    public var analyitcsService: AnalyticsService {
        return adaptyService
    }

    public var analyticsProxy: AnalyticsService? {
        get {
            return adaptyService.analyticsProxy
        }
        set {
            adaptyService.analyticsProxy = newValue
        }
    }

    public var userSettingsService: UserSettingsService = DefaultUserSettingsService()

    public let adaptyService: AdaptyService<Config>
    public init(key: String,
                userId: String? = nil,
                remoteConfigFallback: Config,
                configurator: ((Adapty.Type) -> Void)? = nil) {
        adaptyService = .init(key: key,
                              userId: userId,
                              remoteConfigFallback: remoteConfigFallback,
                              configurator: configurator)
    }
}
