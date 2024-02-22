//
//  ImageUserContent.swift
//
//
//  Created by Anton Kormakov on 18.10.2023.
//

import UIKit
import PurchaseKitCore

final public class ImageUserContent: UIImageView, UserContent {

    public var aspectRatio: CGFloat {
        guard let image = image else {
            return 1.0
        }

        return image.size.width / image.size.height
    }

    public var contentView: UIView {
        return self
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    public override init(image: UIImage?) {
        super.init(image: image)
        setup()
    }

    func setup() {
        clipsToBounds = true
        contentMode = .scaleAspectFill
    }
        
    public func start() {}
    public func stop() {}
}
