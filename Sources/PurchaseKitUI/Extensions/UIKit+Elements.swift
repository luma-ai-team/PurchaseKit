//
//  UIKit+Elements.swift
//  
//
//  Created by Anton Kormakov on 24.10.2023.
//

import UIKit
import PurchaseKitCore

// MARK: - BackgroundTextView

public extension BackgroundTextView {

    func configure(with element: TextElement?, product: Product? = nil) {
        guard let element = element else {
            return
        }

        isHidden = element.isVisible == false

        if let color = element.backgroundColor {
            backgroundStyle.fillColor = color
        }

        if let color = element.textColor {
            textColor = color
        }

        if let font = element.font {
            self.font = font
        }

        if let alignment = element.alignment {
            textAlignment = alignment
        }

        if let text = element.text {
            if let product = product {
                self.text = element.makeFormattedText(for: product)
            }
            else {
                self.text = text
            }
        }
    }
}

// MARK: - UILabel

public extension UILabel {

    func configure(with element: TextElement?, product: Product? = nil) {
        guard let element = element else {
            return
        }

        if let text = element.text {
            if let product = product {
                self.text = element.makeFormattedText(for: product)
            }
            else {
                self.text = text
            }
        }

        if let color = element.textColor {
            textColor = color
        }

        if let color = element.backgroundColor {
            backgroundColor = color
        }

        if let font = element.font {
            self.font = font
        }

        if let alignment = element.alignment {
            textAlignment = alignment
        }

        isHidden = element.isVisible == false
    }
}

// MARK: - UIButton

public extension UIButton {

    func configure(with element: TextElement?, product: Product? = nil) {
        guard let element = element else {
            return
        }

        if let text = element.text {
            if let product = product {
                setTitle(element.makeFormattedText(for: product), for: .normal)
            }
            else {
                setTitle(text, for: .normal)
            }
        }

        if let color = element.textColor {
            setTitleColor(color, for: .normal)
        }

        if let color = element.backgroundColor {
            backgroundColor = color
        }

        if let font = element.font {
            titleLabel?.font = font
        }

        if let alignment = element.alignment {
            titleLabel?.textAlignment = alignment
        }

        isHidden = element.isVisible == false

        guard let actionElement = element as? ActionElement else {
            return
        }

        if let imageName = actionElement.imageName {
            let mode: UIImage.RenderingMode = (actionElement.tintColor == nil) ? .alwaysOriginal : .alwaysTemplate
            if let image = UIImage(named: imageName, in: .module, compatibleWith: nil) {
                setImage(image.withRenderingMode(mode), for: .normal)
            }
            else if let image = UIImage(named: imageName, in: .main, compatibleWith: nil) {
                setImage(image.withRenderingMode(mode), for: .normal)
            }
        }

        if let color = actionElement.tintColor {
            tintColor = color
        }

        if let color = actionElement.shadowColor?.cgColor {
            layer.shadowColor = color
        }
    }
}

// MARK: - UIView

public extension UIView {

    func animateIn(with element: ActionElement?) {
        guard let element = element,
              let delay = element.delay else {
            return
        }

        alpha = 0.0
        DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
            UIView.animate(withDuration: 0.25) {
                self.alpha = 1.0
            }
        })
    }
}
