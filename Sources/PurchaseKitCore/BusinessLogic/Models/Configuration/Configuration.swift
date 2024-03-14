//
//  Configuration.swift
//  
//
//  Created by Anton Kormakov on 18.10.2023.
//

import Foundation
import LumaKit

public struct PurchaseKitConfiguration {
    let isValid: Bool

    public var colorScheme: ColorScheme = .init()
    public var timeout: TimeInterval = 10.0

    public var privacyPolicyURL: URL?
    public var termsOfServiceURL: URL?
    public var contactEmail: String?
    public var appStoreApplicationIdentifier: String?

    private init(isValid: Bool) {
        self.isValid = isValid
    }

    public init() {
        self.isValid = true
    }
}

extension PurchaseKitConfiguration {
    static var invalid: PurchaseKitConfiguration = .init(isValid: false)
}
