//
//  Copyright © 2024 . All rights reserved.
//

import UIKit
import AVFoundation

public final class PremiumHeaderViewModel: Equatable {
    public var title: String?
    public var assetURL: URL?
    public var action: String = "Upgrade to premium"

    public static func == (lhs: PremiumHeaderViewModel, rhs: PremiumHeaderViewModel) -> Bool {
        return (lhs.title == rhs.title) &&
               (lhs.assetURL == rhs.assetURL) &&
               (lhs.action == rhs.action)
    }

    public init() {}
}

public final class SettingsState {
    public var premiumHeaderViewModel: PremiumHeaderViewModel = .init()
    public var premiumPaywallIdentifier: String?

    var sections: [SettingsSection] = []

    public init(premiumHeaderViewModel: PremiumHeaderViewModel = .init(), paywallIdentifier: String) {
        self.premiumHeaderViewModel = premiumHeaderViewModel
        self.premiumPaywallIdentifier = paywallIdentifier
    }
}
