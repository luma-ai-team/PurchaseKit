//
//  Copyright © 2023 Draftz. All rights reserved.
//

import GenericModule

public protocol PaywallViewModelDelegate: AnyObject {
    var state: PaywallState { get }
}

public final class PaywallViewModel: ViewModel {
    let submodules: [any PurchaseKitModule]
    let userContent: [Page.Identifier: UserContent]

    let products: [Product]
    let isLoading: Bool

    let pageIndex: Int

    public init(delegate: PaywallViewModelDelegate) {
        submodules = delegate.state.submodules
        userContent = delegate.state.userContent

        products = delegate.state.products
        isLoading = delegate.state.isLoading

        pageIndex = delegate.state.moduleIndex
    }
}
