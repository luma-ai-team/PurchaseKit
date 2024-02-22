//
//  Screen.swift
//
//  Created by Anton Kormakov on 18.10.2023.
//

import UIKit

public protocol PurchaseKitScreen {
    associatedtype PageType: Page
    typealias ViewModel = PurchaseKitScreenViewModel<PageType>

    var viewModel: ViewModel { get }
    var view: UIView! { get }

    func screenWillAppear()
    func screenDidDisappear()

    func update(with viewModel: ViewModel, force: Bool, animated: Bool)
}

extension PurchaseKitScreen {
    func update(with content: PurchaseKitScreenContent, force: Bool, animated: Bool) {
        let viewModel = ViewModel(page: viewModel.page, colorScheme: viewModel.colorScheme)
        viewModel.content = content
        update(with: viewModel, force: force, animated: animated)
    }
}
