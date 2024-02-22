//
//  File.swift
//  
//
//  Created by Stas Klyukhin on 05.05.2022.
//

import UIKit
import PurchaseKitCore
import LumaKit

public class ActionElement: TextElement {
    public let imageName: String?
    public var gradient: Gradient?
    public let shadowColor: UIColor?
    public var tintColor: UIColor?
    public let delay: TimeInterval?

    enum CodingKeys: String, CodingKey {
        case gradient
        case shadowColor
        case imageName
        case tintColor
        case delay
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        imageName = try container.decodeIfPresent(String.self, forKey: .imageName)
        gradient = try container.decodeIfPresent(Gradient.self, forKey: .gradient)

        if let shadowHexColor = try container.decodeIfPresent(String.self, forKey: .shadowColor) {
            shadowColor = UIColor(string: shadowHexColor)
        }
        else {
            shadowColor = nil
        }

        if let tintHexColor = try container.decodeIfPresent(String.self, forKey: .tintColor) {
            tintColor = UIColor(string: tintHexColor)
        }
        else {
            tintColor = nil
        }
        
        delay = try container.decodeIfPresent(TimeInterval.self, forKey: .delay)
        try super.init(from: decoder)
    }

    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(imageName, forKey: .imageName)
        try container.encodeIfPresent(gradient, forKey: .gradient)
        try container.encodeIfPresent(shadowColor?.stringRepresentation, forKey: .shadowColor)
        try container.encodeIfPresent(tintColor?.stringRepresentation, forKey: .tintColor)
        try container.encodeIfPresent(delay, forKey: .delay)
        try super.encode(to: encoder)
    }
}
