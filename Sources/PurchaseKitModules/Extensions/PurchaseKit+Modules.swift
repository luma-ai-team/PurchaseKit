//
//  File.swift
//  
//
//  Created by Anton Kormakov on 25.10.2023.
//

import UIKit
import PurchaseKitCore
import PurchaseKitUI

public extension PurchaseKit {
    func registerDefaultModules() {
        register(BasicViewController.self)
        register(ReviewViewController.self)
        register(SingleSubscriptionViewController.self)
        register(LongFormSubscriptionViewController.self)
    }

    func showOnboardingIfNeeded(identifier: String,
                                landingViewController: UIViewController,
                                in window: UIWindow? = nil,
                                completion: (() -> Void)? = nil) {
        let target: UIWindow
        let application: UIApplication = .shared
        if let window = window {
            target = window
        }
        else if let window = (application.connectedScenes.first as? UIWindowScene)?.keyWindow {
            target = window
        }
        else if let window = application.keyWindow {
            target = window
        }
        else {
            #if DEBUG
            print("[WW] No suitable window found for presenting \(identifier)")
            #endif

            completion?()
            return
        }

        func setupLandingState(animated: Bool) {
            target.rootViewController = landingViewController
            if animated {
                UIView.transition(with: target, duration: 0.25, options: [.transitionCrossDissolve], animations: {}) { _ in
                    completion?()
                }
            }
            else {
                completion?()
            }
        }

        let controller = PurchaseKitLoadingViewController(colorScheme: configuration.colorScheme)
        target.rootViewController = controller

        registerDefaultModules()
        guard dependencies.userSettingsService.isOnboardingCompleted == false else {
            setupLandingState(animated: false)
            return
        }

        let bindindgs = PaywallBindings()
        bindindgs.completionHandler = { [weak self] in
            self?.dependencies.userSettingsService.isOnboardingCompleted = true
            setupLandingState(animated: true)
        }

        PurchaseKit.shared.present(identifier: "PKOnboarding",
                                   on: controller,
                                   bindings: bindindgs,
                                   failure: { _ in
            setupLandingState(animated: true)
        })

        return
    }
}
