//
//  File.swift
//  
//
//  Created by Anton Kormakov on 25.10.2023.
//

import Foundation
import PurchaseKitCore

public extension PurchaseKit {
    func registerDefaultModules() {
        PurchaseKit.shared.register(BasicViewController.self)
        PurchaseKit.shared.register(ReviewViewController.self)
    }
}
