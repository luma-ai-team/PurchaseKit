//
//  Page.swift
//  
//
//  Created by Anton Kormakov on 18.10.2023.
//

import Foundation

public protocol Page: Codable {
    typealias Identifier = String
    static var type: String { get }

    var identifier: Identifier { get }
    var hasProducts: Bool { get }
}

extension Page {
    var type: String {
        return Self.type
    }
}
