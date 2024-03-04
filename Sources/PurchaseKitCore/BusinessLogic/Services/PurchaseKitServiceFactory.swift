//
//  PurchaseKitServiceFactory.swift
//  
//
//  Created by Anton Kormakov on 19.10.2023.
//

import Foundation

public typealias PurchaseKitServiceFactory = HasPaywallService &
                                             HasStoreService &
                                             HasRemoteConfigService &
                                             HasAnalyticsService &
                                             HasUserSettingsService

open class DummyPurchaseKitServiceFactory: PurchaseKitServiceFactory {
    public var paywallService: PaywallService
    public lazy var storeService: StoreService = DummyStoreService(products: [])
    public lazy var remoteConfigService: any RemoteConfigService = DummyRemoteConfigService(fallback: .init())
    public lazy var analyitcsService: AnalyticsService = DummyAnalyticsService()
    public lazy var userSettingsService: UserSettingsService = DefaultUserSettingsService()

    public init(url: URL, products: [Product]) throws {
        paywallService = try DummyPaywallService(url: url)
        storeService = DummyStoreService(products: products)
    }
}
