//
//  GradientButton.swift
//  
//
//  Created by Anton Kormakov on 24.10.2023.
//

import UIKit
import PurchaseKitCore
import PurchaseKitUI
import LumaKit

public extension GradientButton {

    func configure(with element: ActionElement?, product: Product? = nil) {
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

        if let imageName = element.imageName {
            let mode: UIImage.RenderingMode = (element.tintColor == nil) ? .alwaysOriginal : .alwaysTemplate
            if let image = UIImage(named: imageName, in: .module, compatibleWith: nil) {
                setImage(image.withRenderingMode(mode), for: .normal)
            }
            else if let image = UIImage(named: imageName, in: .main, compatibleWith: nil) {
                setImage(image.withRenderingMode(mode), for: .normal)
            }
        }

        if let color = element.tintColor {
            tintColor = color
        }

        if let color = element.shadowColor?.cgColor {
            layer.shadowColor = color
        }

        if let gradient = element.gradient {
            self.gradient = gradient
        }
    }
}
