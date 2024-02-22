//
//  AssetElement.swift
//  
//
//  Created by Anton Kormakov on 20.10.2023.
//

import UIKit

public class AssetElement: Codable {
    enum CodingKeys: CodingKey {
        case asset
        case backgroundColor
    }

    public var asset: String?
    public var backgroundColor: UIColor?

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        asset = try container.decodeIfPresent(String.self, forKey: .asset)

        if let colorString = try? container.decode(String.self, forKey: .backgroundColor) {
            backgroundColor = UIColor(string: colorString)
        }
        else {
            backgroundColor = nil
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(asset, forKey: .asset)
        try container.encodeIfPresent(backgroundColor?.stringRepresentation, forKey: .backgroundColor)
    }
}
