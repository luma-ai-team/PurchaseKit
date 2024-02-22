//
//  Copyright © 2023 Draftz. All rights reserved.
//

import Foundation
import GenericModule

public protocol PaywallModuleInput: PurchaseKitModuleOutput {
    var state: PaywallState { get }
}

public protocol PaywallModuleOutput: AnyObject {
    func paywallModuleDidRequestContent(_ sender: PaywallModuleInput, for page: any Page) -> UserContent?

    func paywallModuleDidPurchase(_ sender: PaywallModuleInput, product: Product)
    func paywallModuleDidFail(_ sender: PaywallModuleInput, with error: Error)

    func paywallModuleDidFinish(_ sender: PaywallModuleInput)
}

public typealias PaywallModuleDependencies = PurchaseKitServiceFactory

public final class PaywallModule: Module<PaywallPresenter> {
    //
}
