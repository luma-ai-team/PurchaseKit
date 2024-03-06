//
//  File.swift
//  
//
//  Created by Anton Kormakov on 05.03.2024.
//

import PurchaseKitCore
import PurchaseKitUI

open class LongFormSubscriptionPage: Page {
    public struct Feature: Codable {
        public let emoji: String
        public let title: TextElement
    }

    public struct Testimonial: Codable, Equatable {
        public let rating: Float
        public let message: String
        public let author: String?
    }

    public static var type: String = "LongFormSubscriptionViewController"

    public var identifier: Identifier {
        return Self.type
    }

    public let hasProducts: Bool = true

    public var asset: String?
    public var title: TextElement?
    public var subtitle: TextElement?
    public var features: [Feature]
    public var testimonials: [Testimonial]

    public var action: ActionElement?
    public var closeAction: ActionElement?
}
