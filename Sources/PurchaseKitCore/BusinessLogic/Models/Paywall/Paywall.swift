//
//  Paywall.swift
//  
//
//  Created by Anton Kormakov on 18.10.2023.
//

import Foundation

public final class Paywall {
    enum CodingKeys: CodingKey {
        case identifier
        case presentationStyle
        case pages
    }

    public let identifier: String
    public let presentationStyle: PresentationStyle
    public var pages: [any Page]

    public init(identifier: String, presentationStyle: PresentationStyle = .init(), pages: [any Page]) {
        self.identifier = identifier
        self.presentationStyle = presentationStyle
        self.pages = pages
    }
}
