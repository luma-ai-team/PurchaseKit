//
//  File.swift
//  
//
//  Created by Anton Kormakov on 21.02.2024.
//

import PurchaseKitCore
import PurchaseKitUI

open class ReviewPage: Page {
    public static var type: String = "ReviewViewController"

    public var identifier: Identifier {
        return Self.type
    }

    public let hasProducts: Bool = false

    public var title: TextElement?
    public var subtitle: TextElement?

    public var action: ActionElement?
    public var rating: Float
}


