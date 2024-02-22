//
//  DummyStoreService.swift
//  
//
//  Created by Anton Kormakov on 18.10.2023.
//

import Foundation

public final class DummyStoreService: StoreService {
    public var isAnyProductPurchased: Bool {
        return isPurchased
    }

    public var isAnySubscriptionActive: Bool {
        return isPurchased
    }

    let products: [Product]
    var isPurchased: Bool = false

    public init(products: [Product]) {
        self.products = products
    }

    public func fetchProducts(for paywall: Paywall, success: ([Product]) -> Void, failure: (Error) -> Void) {
        success(products)
    }

    public func purchase(_ product: Product, from paywall: Paywall, success: (Product) -> Void, failure: (Error) -> Void) {
        isPurchased = true
        success(product)
    }

    public func restore(success: () -> Void, failure: (Error) -> Void) {
        isPurchased = true
        success()
    }
}
