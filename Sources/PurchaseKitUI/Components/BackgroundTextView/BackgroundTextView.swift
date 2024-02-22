//
//  BackgroundTextView.swift
//
//
//  Created by Anton Kormakov on 20.10.2023.
//

import UIKit

open class BackgroundTextView: UITextView, NSLayoutManagerDelegate {

    public class BackgroundStyle {
        public var cornerRadius: CGFloat = 3.0
        public var fillColor: UIColor = .clear
        public var padding: CGSize = .init(width: 3.0, height: 3.0)
    }

    public var backgroundStyle: BackgroundStyle = .init() {
        didSet {
            if backgroundStyle.fillColor == .clear {
                textContainer.lineFragmentPadding = 0.0
            }
            else {
                textContainer.lineFragmentPadding = backgroundStyle.padding.width + 5.0
            }
            setNeedsDisplay()
        }
    }

    public var lineSpacing: CGFloat = 15.0 {
        didSet {
            setNeedsDisplay()
        }
    }

    open override var textAlignment: NSTextAlignment {
        didSet {
            setNeedsDisplay()
        }
    }

    open override var text: String! {
        get {
            return attributedText.string
        } set {
            guard let newValue = newValue else {
                attributedText = .init()
                return
            }

            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = lineSpacing
            paragraphStyle.alignment = textAlignment

            let attributes: [NSAttributedString.Key: Any] = [
                .paragraphStyle: paragraphStyle,
                .font: font as Any,
                .foregroundColor: textColor ?? .white
            ]

            attributedText = NSAttributedString(string: newValue, attributes: attributes)
            setNeedsDisplay()
        }
    }

    public override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        setup()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        isSelectable = false
        isUserInteractionEnabled = false
        isEditable = false
        clipsToBounds = false
        
        _ = layoutManager
    }
    
    open override func draw(_ rect: CGRect) {
        guard let layoutManager = textContainer.layoutManager else {
            return
        }

        let glyphRange = layoutManager.glyphRange(for: textContainer)
        let commonLineHeight: CGFloat = {
            var commonLineHeight: CGFloat = .greatestFiniteMagnitude
            layoutManager.enumerateLineFragments(forGlyphRange: glyphRange) { (_, usedRect, _, _, _) in
                commonLineHeight = min(commonLineHeight, usedRect.height)
            }
            return commonLineHeight
        }()

        let padding = backgroundStyle.padding
        let cornerRadius = backgroundStyle.cornerRadius
        let fillColor = backgroundStyle.fillColor
        let lineSpacing = self.lineSpacing

        fillColor.setFill()
        let origin = layoutManager.usedRect(for: textContainer).origin
        layoutManager.enumerateLineFragments(forGlyphRange: glyphRange) { (_, rect: CGRect, _, _, _) in
            var usedRect = rect
            usedRect.origin.y += 0.6 * lineSpacing
            usedRect.size.height = commonLineHeight

            var rect = usedRect.offsetBy(dx: origin.x, dy: origin.y).insetBy(dx: 0.0, dy: -padding.height)
            rect.origin.x = max(rect.origin.x, 0.0)
            rect.size.width = min(rect.size.width, self.bounds.width)
            let path = UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius)
            path.fill()
        }
    }
    
}
