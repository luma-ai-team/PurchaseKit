//
//  PurchaseKit+Settings.swift
//
//
//  Created by Anton Kormakov on 13.03.2024.
//

import UIKit
import PurchaseKitCore

public extension PurchaseKit {
    func showAppSettings(with state: SettingsState, on controller: UIViewController) {
        let coordinator = SettingsCoordinator(rootViewController: controller)
        coordinator.start(with: state)
    }
}
