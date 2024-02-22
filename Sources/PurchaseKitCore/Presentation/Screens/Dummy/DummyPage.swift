//
//  DummyPage.swift
//  
//
//  Created by Anton Kormakov on 18.10.2023.
//

import Foundation

public final class DummyPage: Page, Codable {
    enum CodingKeys: CodingKey {
        case hasProducts
        case value
    }

    public static var type: String = "dummy"

    public var identifier: String = UUID().uuidString
    public var hasProducts: Bool = false

    public var value: Int = 0

    public init() {}
}
