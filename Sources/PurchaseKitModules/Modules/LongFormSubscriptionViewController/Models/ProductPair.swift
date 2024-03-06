//
//  File.swift
//  
//
//  Created by Anton Kormakov on 06.03.2024.
//

import Foundation
import PurchaseKitCore

final class ProductPair {
    let baseProduct: Product
    let alternativeProduct: Product?

    var duration: Product.Duration {
        return baseProduct.duration ?? .unknown
    }

    init(baseProduct: Product, alternativeProduct: Product?) {
        self.baseProduct = baseProduct
        self.alternativeProduct = alternativeProduct
    }
}
