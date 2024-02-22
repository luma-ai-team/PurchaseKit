//
//  StoreService.swift
//  
//
//  Created by Anton Kormakov on 18.10.2023.
//

import Foundation

public protocol HasStoreService {
    var storeService: StoreService { get }
}

public protocol StoreService: AnyObject {

    var isAnyProductPurchased: Bool { get }
    var isAnySubscriptionActive: Bool { get }

    func fetchProducts(for paywall: Paywall,
                       success: @escaping ([Product]) -> Void,
                       failure: @escaping (Error) -> Void)
    func purchase(_ product: Product,
                  from paywall: Paywall,
                  success: @escaping (Product) -> Void,
                  failure: @escaping (Error) -> Void)
    func restore(success: @escaping () -> Void, failure: @escaping (Error) -> Void)
}
