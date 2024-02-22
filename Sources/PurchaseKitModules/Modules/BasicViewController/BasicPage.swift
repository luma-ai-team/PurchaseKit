//
//  BasicPage.swift
//  
//
//  Created by Anton Kormakov on 24.10.2023.
//

import PurchaseKitCore
import PurchaseKitUI

open class BasicPage: Page {
    public static var type: String = "BasicViewController"

    public var identifier: Identifier {
        return Self.type
    }

    public let hasProducts: Bool

    public var asset: String?
    public var title: TextElement?
    public var subtitle: TextElement?

    public var action: ActionElement?
    public var closeAction: ActionElement?
}

