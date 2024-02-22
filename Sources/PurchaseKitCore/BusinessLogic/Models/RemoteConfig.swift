//
//  RemoteConfig.swift
//  
//
//  Created by Anton Kormakov on 19.10.2023.
//

import Foundation

public protocol RemoteConfig: Codable {
    static var identifier: String { get }
    var paywallIdentifierOverride: String? { get }
    var premiumEventTriggerLimit: Int? { get }
}

public class DefaultRemoteConfig: RemoteConfig, Codable {
    static public var identifier: String = "RemoteConfig"

    public let paywallIdentifierOverride: String?
    public let premiumEventTriggerLimit: Int?

    public init(paywallIdentifierOverride: String? = nil,
                premiumEventTriggerLimit: Int? = nil) {
        self.paywallIdentifierOverride = paywallIdentifierOverride
        self.premiumEventTriggerLimit = premiumEventTriggerLimit
    }
}
