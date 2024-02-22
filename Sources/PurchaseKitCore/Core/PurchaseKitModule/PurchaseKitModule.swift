//
//  PurchaseKit.swift
//  
//
//  Created by Anton Kormakov on 18.10.2023.
//

import UIKit
import GenericModule
import LumaKit

public protocol PurchaseKitModuleOutput: AnyObject {
    func moduleDidRequestNextPage(_ page: Page)
    func moduleDidRequestDismiss(_ page: Page)
    func moduleDidRequestPurchase(_ page: Page, product: Product)
    func moduleDidRequestRestorePurchases(_ page: Page)
    func moduleDidRequestPrivacyPolicy(_ page: Page)
    func moduleDidRequestTermsOfService(_ page: Page)
    func moduleDidRequestAppReview(_ page: Page)
}

public protocol PurchaseKitModule: AnyObject {
    associatedtype ScreenType: PurchaseKitScreen

    var output: PurchaseKitModuleOutput? { get set }
    var screen: ScreenType { get }

    init(viewModel: ScreenType.ViewModel, output: PurchaseKitModuleOutput?)
}

extension PurchaseKitModule {
    var page: any Page {
        return screen.viewModel.page
    }

    var hasProducts: Bool {
        return page.hasProducts
    }
}

extension PurchaseKitModule {
    static var type: String {
        return ScreenType.PageType.type
    }

    static func makePage(using decoder: Decoder) throws -> ScreenType.PageType {
        var container = try decoder.unkeyedContainer()
        return try container.decode(ScreenType.PageType.self)
    }

    static func makePage(using container: inout UnkeyedDecodingContainer) throws -> ScreenType.PageType {
        return try container.decode(ScreenType.PageType.self)
    }

    static func makeViewModel(for page: any Page, colorScheme: ColorScheme) -> ScreenType.ViewModel? {
        guard let page = page as? ScreenType.PageType else {
            return nil
        }

        return PurchaseKitScreenViewModel<ScreenType.PageType>(page: page, colorScheme: colorScheme)
    }

    static func makeModule(for page: any Page, colorScheme: ColorScheme, output: PurchaseKitModuleOutput?) -> Self? {
        guard let viewModel = makeViewModel(for: page, colorScheme: colorScheme) else {
            return nil
        }

        return Self.init(viewModel: viewModel, output: output)
    }
}

extension PurchaseKitModule where Self: UIViewController {
    public var screen: Self {
        return self
    }
}
