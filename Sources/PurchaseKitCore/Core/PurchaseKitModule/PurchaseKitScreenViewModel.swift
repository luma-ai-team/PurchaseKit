//
//  ScreenViewModel.swift
//  
//
//  Created by Anton Kormakov on 18.10.2023.
//

import Foundation
import LumaKit

public class PurchaseKitScreenContent {
    public var userContent: UserContent? = nil

    public var products: [Product] = []
    public var isLoading: Bool = false

    public init() {}
}

open class PurchaseKitScreenViewModel<T: Page> {
    public let page: T
    public var colorScheme: ColorScheme
    public var content: PurchaseKitScreenContent = .init()

    init(page: T, colorScheme: ColorScheme) {
        self.page = page
        self.colorScheme = colorScheme
    }
}
