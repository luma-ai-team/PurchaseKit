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
        register(BasicViewController.self)
        register(ReviewViewController.self)
        register(SingleSubscriptionViewController.self)
        register(LongFormSubscriptionViewController.self)
    }
}
