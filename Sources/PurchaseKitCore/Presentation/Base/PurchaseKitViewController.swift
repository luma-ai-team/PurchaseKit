//
//  PurchaseKitViewController.swift
//  
//
//  Created by Anton Kormakov on 18.10.2023.
//

import UIKit
import GenericModule

open class PurchaseKitViewController<PageType: Page>: UIViewController, PurchaseKitModule, PurchaseKitScreen {
    public typealias PageType = PageType

    public var viewModel: PurchaseKitScreenViewModel<PageType>
    public weak var output: PurchaseKitModuleOutput?

    required public init(viewModel: PurchaseKitScreenViewModel<PageType>, output: PurchaseKitModuleOutput?) {
        self.viewModel = viewModel
        self.output = output
        super.init(nibName: nil, bundle: nil)
        update(with: viewModel, force: true, animated: false)
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    open func screenWillAppear() {
        //
    }

    open func screenDidDisappear() {
        //
    }

    open func update(with viewModel: PurchaseKitScreenViewModel<PageType>, force: Bool, animated: Bool) {
        let viewUpdate = Update(newModel: viewModel, oldModel: self.viewModel, force: force)
        self.viewModel = viewModel
        update(with: viewUpdate, animated: animated)
    }

    open func update(with viewUpdate: Update<PurchaseKitScreenViewModel<PageType>>, animated: Bool) {

    }
}
