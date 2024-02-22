//
//  PaywallPresentationStyle.swift
//  
//
//  Created by Anton Kormakov on 25.10.2023.
//

import UIKit

public final class PresentationStyle: Codable {
    public enum PresentationType: String, Codable {
        case fullScreen
        case pageSheet

        public var uiModalPresentationStyle: UIModalPresentationStyle {
            switch self {
            case .fullScreen:
                return .overFullScreen
            case .pageSheet:
                return .pageSheet
            }
        }
    }

    public enum TransitionType: String, Codable {
        case none
        case slide
        case crossDissolve

        public var uiModalTransitionStyle: UIModalTransitionStyle {
            switch self {
            case .slide, .none:
                return .coverVertical
            case .crossDissolve:
                return .crossDissolve
            }
        }
    }

    enum CodingKeys: CodingKey {
        case type
        case transition
    }

    public let type: PresentationType
    public let transition: TransitionType

    public init(type: PresentationType = .fullScreen, transition: TransitionType = .crossDissolve) {
        self.type = type
        self.transition = transition
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        type = (try? container.decodeIfPresent(PresentationType.self, forKey: .type)) ?? .fullScreen
        transition = (try? container.decodeIfPresent(TransitionType.self, forKey: .transition)) ?? .crossDissolve
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(type, forKey: .type)
        try container.encode(transition, forKey: .transition)
    }
}
