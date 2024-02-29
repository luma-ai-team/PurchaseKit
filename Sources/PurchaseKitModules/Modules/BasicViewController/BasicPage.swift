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

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.hasProducts = try container.decodeIfPresent(Bool.self, forKey: .hasProducts) ?? false
        self.asset = try container.decodeIfPresent(String.self, forKey: .asset)
        self.title = try container.decodeIfPresent(TextElement.self, forKey: .title)
        self.subtitle = try container.decodeIfPresent(TextElement.self, forKey: .subtitle)
        self.action = try container.decodeIfPresent(ActionElement.self, forKey: .action)
        self.closeAction = try container.decodeIfPresent(ActionElement.self, forKey: .closeAction)
    }
}

