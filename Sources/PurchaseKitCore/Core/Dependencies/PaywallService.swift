//
//  PaywallService.swift
//  
//
//  Created by Anton Kormakov on 18.10.2023.
//

import Foundation

public protocol HasPaywallService {
    var paywallService: PaywallService { get }
}

public protocol PaywallService: AnyObject {
    func fetch(identifier: String,
               builder: PaywallBuilder,
               success: @escaping (Paywall) -> Void,
               failure: @escaping (Error) -> Void)
}
