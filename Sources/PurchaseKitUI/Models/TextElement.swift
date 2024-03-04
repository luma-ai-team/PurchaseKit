//
//  File.swift
//  
//
//  Created by Stas Klyukhin on 05.05.2022.
//

import Foundation
import UIKit

public class TextElement: Codable {
    enum CodingKeys: String, CodingKey {
        case text
        case fontName
        case fontSize
        case alignment
        case textColor
        case backgroundColor
        case isVisible
    }

    public var text: String?
    public var fontName: String?
    public var fontSize: CGFloat?
    public var alignment: NSTextAlignment?
    public var textColor: UIColor?
    public var backgroundColor: UIColor?
    public var isVisible: Bool = true

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        text = try container.decodeIfPresent(String.self, forKey: .text)
        fontName = try container.decodeIfPresent(String.self, forKey: .fontName)
        fontSize = try container.decodeIfPresent(CGFloat.self, forKey: .fontSize)

        if let alignmentString = try container.decodeIfPresent(String.self, forKey: .alignment) {
            alignment = .init(string: alignmentString)
        }
        else {
            alignment = nil
        }

        if let textColorString = try container.decodeIfPresent(String.self, forKey: .textColor) {
            textColor = .init(string: textColorString)
        }
        else {
            textColor = nil
        }

        if let backgroundColorString = try container.decodeIfPresent(String.self, forKey: .backgroundColor) {
            backgroundColor = .init(string: backgroundColorString)
        }
        else {
            backgroundColor = nil
        }

        isVisible = try container.decodeIfPresent(Bool.self, forKey: .isVisible) ?? true
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(text, forKey: .text)
        try container.encodeIfPresent(fontName, forKey: .fontName)
        try container.encodeIfPresent(fontSize, forKey: .fontSize)
        try container.encodeIfPresent(alignment?.stringValue, forKey: .alignment)
        try container.encodeIfPresent(textColor?.stringRepresentation, forKey: .textColor)
        try container.encodeIfPresent(backgroundColor?.stringRepresentation, forKey: .backgroundColor)
        try container.encode(isVisible, forKey: .isVisible)
    }

    public init(text: String) {
        self.text = text
    }
}

// MARK: - UIFont

extension TextElement {
    static let systemFontTag = "system"
    static let fontSizeMarker: Character = "/"

    enum SystemFontWeight: String {
        case ultraLight
        case thin
        case light
        case regular
        case medium
        case semibold
        case bold
        case heavy
        case black

        var weight: UIFont.Weight {
            switch self {
            case .ultraLight:
                return .ultraLight
            case .thin:
                return .thin
            case .light:
                return .light
            case .regular:
                return .regular
            case .medium:
                return .medium
            case .semibold:
                return .semibold
            case .bold:
                return .bold
            case .heavy:
                return .heavy
            case .black:
                return .black
            }
        }
    }

    enum SystemFontModifier: String {
        case rounded
        case serif
        case monospaced

        var design: UIFontDescriptor.SystemDesign {
            switch self {
            case .rounded:
                return .rounded
            case .serif:
                return .serif
            case .monospaced:
                return .monospaced
            }
        }
    }

    public var font: UIFont? {
        if fontName == nil,
           fontSize == nil {
            return nil
        }

        let fallbackSize: CGFloat = 12.0
        var size = fontSize ?? fallbackSize
        guard var name = fontName else {
            return .systemFont(ofSize: size)
        }

        if let suffixIndex = name.lastIndex(of: Self.fontSizeMarker) {
            let suffix = String(name.suffix(from: name.index(after: suffixIndex)))
            name = String(name.prefix(upTo: suffixIndex))
            if let requestedSize = Double(suffix) {
                size = CGFloat(requestedSize)
            }
        }

        let components = name.split(separator: "-").map(String.init)
        var componentIterator = components.makeIterator()
        guard componentIterator.next() == Self.systemFontTag else {
            return .init(name: name, size: size) ?? .systemFont(ofSize: size)
        }

        let leadingTag = componentIterator.next()
        let trailingTag = componentIterator.next()

        let modifier: String?
        let weight: String?
        if trailingTag != nil {
            modifier = leadingTag
            weight = trailingTag
        }
        else {
            weight = leadingTag
            modifier = nil
        }

        let fontWeight = SystemFontWeight(rawValue: weight ?? .init())
        let fontModifier = SystemFontModifier(rawValue: modifier ?? .init())
        let baseFont: UIFont = .systemFont(ofSize: size, weight: fontWeight?.weight ?? .regular)
        if let fontModifier = fontModifier,
           let descriptor = baseFont.fontDescriptor.withDesign(fontModifier.design) {
            return UIFont(descriptor: descriptor, size: baseFont.pointSize)
        }

        return baseFont
    }
}
