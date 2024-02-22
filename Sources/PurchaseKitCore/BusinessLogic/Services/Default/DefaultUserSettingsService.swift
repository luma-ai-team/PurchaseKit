//
//  File.swift
//  
//
//  Created by Anton Kormakov on 21.02.2024.
//

import Foundation
import LumaKit

public final class DefaultUserSettingsService: UserSettingsService {
    private static var container: UserDefaults = .init(suiteName: "purchase-kit") ?? .standard

    public var userIdentifier: String {
        let key = "userIdentifier"
        guard let identifier = Self.container.string(forKey: key) else {
            let identifier = UUID().uuidString
            Self.container.set(identifier, forKey: key)
            CFPreferencesAppSynchronize(kCFPreferencesCurrentApplication)
            return identifier
        }

        return identifier
    }

    @UserDefault(key: "isOnboardingCompleted", defaultValue: false, container: container)
    public var isOnboardingCompleted: Bool

    @UserDefault(key: "premiumEventTriggerCount", defaultValue: 0, container: container)
    public var premiumEventTriggerCount: Int

    public init() {}
}
