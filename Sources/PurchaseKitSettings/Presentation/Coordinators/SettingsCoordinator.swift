//
//  File.swift
//  
//
//  Created by Anton Kormakov on 14.03.2024.
//

import UIKit
import MessageUI
import LumaKit
import GenericModule
import PurchaseKitCore
import PurchaseKitUI

public final class SettingsCoordinator: Coordinator<UIViewController> {

    public func start(with state: SettingsState) {
        let viewController = makeSettingsViewController(with: state)
        rootViewController.present(viewController, animated: true)
    }

    public func makeSettingsViewController(with state: SettingsState) -> UIViewController {
        let module = SettingsModule(state: state, dependencies: [], output: self)
        module.viewController.modalPresentationStyle = .overFullScreen
        return module.viewController
    }
}

// MARK: - SettingsModuleOutput

extension SettingsCoordinator: SettingsModuleOutput {
    public func settingsModuleDidRequestContact(_ sender: SettingsModuleInput, email: String) {
        let displayName = Bundle.main.appDisplayName ?? "N/A"
        let version = Bundle.main.appVersion
        let build = Bundle.main.buildIdentifier ?? "N/A"

        let subject = "Support for \(displayName)"
        let application = "App: \(displayName) \(version) (\(build))"
        let device = "Device: \(UIDevice.current.modelName)"
        let system = "OS: \(UIDevice.current.systemVersion)"
        let userIdentifier = "User: \(PurchaseKit.shared.dependencies.userSettingsService.userIdentifier)"
        let body = "\n\n\n\n\n\(application)\n\(device)\n\(system)\n\(userIdentifier)\n"

        guard MFMailComposeViewController.canSendMail() else {
            var components = URLComponents()
            components.scheme = "mailto"
            components.path = email
            components.queryItems = [
                .init(name: "subject", value: subject),
                .init(name: "body", value: body)
            ]

            if let url = components.url {
                UIApplication.shared.open(url)
            }
            return
        }

        let controller = MFMailComposeViewController()
        controller.mailComposeDelegate = self
        controller.setToRecipients([email])
        controller.setSubject(subject)
        controller.setMessageBody(body, isHTML: false)
        topViewController.present(controller, animated: true)
    }

    public func settingsModuleDidRequestShareApp(_ sender: SettingsModuleInput, identifier: String) {
        let item = ShareAppAcitivtyItem(applicationIdentifier: identifier, displayName: Bundle.main.appDisplayName)
        let controller = UIActivityViewController(activityItems: [item], applicationActivities: nil)
        controller.excludedActivityTypes = [
            .addToReadingList,
            .assignToContact,
            .markupAsPDF,
            .openInIBooks,
            .saveToCameraRoll
        ]
        controller.popoverPresentationController?.sourceView = topViewController.view
        topViewController.present(controller, animated: true)
    }

    public func settingsModuleDidRequestOpen(_ sender: SettingsModuleInput, url: URL) {
        UIApplication.shared.open(url)
    }

    public func settingsModuleDidRequestPaywall(_ sender: SettingsModuleInput, identifier: String) {
        let bindings: PaywallBindings = .init()
        bindings.completionHandler = { [weak sender] in
            sender?.update(force: false, animated: false)
        }
        PurchaseKit.shared.present(identifier: identifier, on: topViewController, bindings: bindings)
    }

    public func settingsModuleDidRequestRestore(_ sender: SettingsModuleInput) {
        let controller = PurchaseKitRestoreViewController(colorScheme: PurchaseKit.shared.configuration.colorScheme)
        topViewController.present(controller, animated: true)

        PurchaseKit.shared.dependencies.storeService.restore { [weak sender] in
            sender?.update(force: false, animated: false)
            controller.dismiss(animated: true)
        } failure: { _ in
            controller.dismiss(animated: true)
        }
    }

    public func settingsModuleDidRequestDismiss(_ sender: SettingsModuleInput) {
        rootViewController.dismiss(animated: true)
    }
}

// MARK: - MFMailComposeViewControllerDelegate

extension SettingsCoordinator: MFMailComposeViewControllerDelegate {
    public func mailComposeController(_ controller: MFMailComposeViewController, 
                                      didFinishWith result: MFMailComposeResult,
                                      error: Error?) {
        controller.dismiss(animated: true)
    }
}
