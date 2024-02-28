//
//  File.swift
//  
//
//  Created by Anton Kormakov on 28.02.2024.
//

import PurchaseKitCore
import PurchaseKitUI

open class SingleSubscriptionPage: Page {
    open class Feature: Codable {
        public let emoji: String
        public let title: TextElement
    }

    public static var type: String = "SingleSubscriptionViewController"

    public var identifier: Identifier {
        return Self.type
    }

    public let hasProducts: Bool = true

    public var asset: String?
    public var title: TextElement?
    public var subtitle: TextElement?

    public var features: [Feature]

    public var action: ActionElement?
    public var closeAction: ActionElement?
}


