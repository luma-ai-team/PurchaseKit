//
//  File.swift
//  
//
//  Created by Stas Klyukhin on 22.06.2022.
//

import UIKit

public extension ActionElement {

    var image: UIImage? {
        if let imageName = imageName {
            return UIImage(named: imageName, in: .main, compatibleWith: nil)// ??
                   //UIImage(named: imageName, in: .module, compatibleWith: nil)

        }
        else {
            return nil
        }
    }
}
