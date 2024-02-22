//
//  PaywallBindings.swift
//  
//
//  Created by Anton Kormakov on 20.10.2023.
//

public final class PaywallBindings: PaywallModuleOutput {
    public var userContentProvider: ((any Page) -> UserContent?)?
    public var purchaseHandler: ((Product) -> Void)?
    public var errorHandler: ((Error) -> Void)?
    public var completionHandler: (() -> Void)?

    public init() {}

    public func paywallModuleDidRequestContent(_ sender: PaywallModuleInput, for page: any Page) -> UserContent? {
        userContentProvider?(page)
    }

    public func paywallModuleDidPurchase(_ sender: PaywallModuleInput, product: Product) {
        purchaseHandler?(product)
    }

    public func paywallModuleDidFail(_ sender: PaywallModuleInput, with error: Error) {
        errorHandler?(error)
    }

    public func paywallModuleDidFinish(_ sender: PaywallModuleInput) {
        completionHandler?()
    }
}
