//
//  Copyright © 2023 Draftz. All rights reserved.
//

import UIKit

public final class PaywallState {
    public let paywall: Paywall
    public let configuration: PurchaseKitConfiguration
    public internal(set) var context: UIViewController?

    let identifier: String = UUID().uuidString
    let submodules: [any PurchaseKitModule]

    var products: [Product] = []
    var userContent: [Page.Identifier: UserContent] = [:]

    var moduleIndex: Int = 0 {
        didSet {
            moduleIndex = min(max(moduleIndex, 0), submodules.count - 1)
        }
    }

    var isLoading: Bool = false
    var isProductFetchFailed: Bool = false

    var currentModule: (any PurchaseKitModule) {
        return submodules[moduleIndex]
    }

    public init(paywall: Paywall, configuration: PurchaseKitConfiguration, submodules: [any PurchaseKitModule] = []) {
        self.paywall = paywall
        self.configuration = configuration
        self.submodules = submodules
    }
}
