//
//  NSTextAlignment+Convenience.swift
//  
//
//  Created by Anton Kormakov on 20.10.2023.
//

import UIKit

extension NSTextAlignment {
    static var map: [String: NSTextAlignment] = [
        "left": .left,
        "center": .center,
        "right": .right,
        "justified": .justified,
        "natural": .natural
    ]

    init?(string: String) {
        guard let value = Self.map[string] else {
            return nil
        }

        self = value
    }

    var stringValue: String? {
        return Self.map.first { (key: String, value: NSTextAlignment) in
            return value == self
        }?.key
    }
}
