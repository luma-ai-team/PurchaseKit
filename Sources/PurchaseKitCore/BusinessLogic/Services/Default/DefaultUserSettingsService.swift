//
//  File.swift
//  
//
//  Created by Anton Kormakov on 21.02.2024.
//

import Foundation
import LumaKit

public final class DefaultUserSettingsService: UserSettingsService {
    enum Constants {
        static let userIdentifierKey: String = "userIdentifier"
    }

    private static var container: UserDefaults = .init(suiteName: "purchase-kit") ?? .standard

    public var userIdentifier: String {
        get {
            guard let identifier = Self.container.string(forKey: Constants.userIdentifierKey) else {
                let identifier = UUID().uuidString
                Self.container.set(identifier, forKey: Constants.userIdentifierKey)
                CFPreferencesAppSynchronize(kCFPreferencesCurrentApplication)
                return identifier
            }

            return identifier
        }
        set {
            Self.container.set(newValue, forKey: Constants.userIdentifierKey)
            CFPreferencesAppSynchronize(kCFPreferencesCurrentApplication)
        }
    }

    @UserDefault(key: "isOnboardingCompleted", defaultValue: false, container: container)
    public var isOnboardingCompleted: Bool

    @UserDefault(key: "premiumEventTriggerCount", defaultValue: 0, container: container)
    public var premiumEventTriggerCount: Int

    public init() {}
}
