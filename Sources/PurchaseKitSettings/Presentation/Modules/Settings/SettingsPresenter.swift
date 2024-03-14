//
//  Copyright © 2024 . All rights reserved.
//

import UIKit
import PurchaseKitCore
import GenericModule

final class SettingsPresenter: Presenter<SettingsState,
                                         SettingsViewController,
                                         SettingsModuleInput,
                                         SettingsModuleOutput,
                                         SettingsModuleDependencies> {
    override func update(force: Bool = false, animated: Bool) {
        state.sections = [
            makePremiumSection(),
            makeContactsSection(),
            makeLegalSection()
        ]

        super.update(force: force, animated: animated)
    }

    private func makePremiumSection() -> SettingsSection {
        let isSubscribed = PurchaseKit.shared.dependencies.storeService.isAnySubscriptionActive
        if state.premiumHeaderViewModel.title == nil {
            let applicationName = Bundle.main.appDisplayName ?? .init()
            state.premiumHeaderViewModel.title = "Unlock the full potential of \(applicationName)"
        }

        return SettingsSection(header: .premium(state.premiumHeaderViewModel, isSubscribed: isSubscribed))
    }

    private func makeContactsSection() -> SettingsSection {
        let section = SettingsSection(header: .none)
        if let email = PurchaseKit.shared.configuration.contactEmail {
            let action = SettingsAction(title: "Contact Us", handler: { [weak self] in
                self?.showContactUsFlow(email: email)
            })
            section.actions.append(action)
        }
        if PurchaseKit.shared.dependencies.storeService.isAnySubscriptionActive == false {
            let action = SettingsAction(title: "Restore Purchases", handler: { [weak self] in
                self?.showRestorePurchasesFlow()
            })
            section.actions.append(action)
        }
        if let applicationIdentifier = PurchaseKit.shared.configuration.appStoreApplicationIdentifier {
            let action = SettingsAction(title: "Share with Friends", handler: { [weak self] in
                self?.showShareAppFlow(identifier: applicationIdentifier)
            })
            section.actions.append(action)
        }
        return section
    }

    private func makeLegalSection() -> SettingsSection {
        let section = SettingsSection(header: .title("Legal"))
        if let url = PurchaseKit.shared.configuration.privacyPolicyURL {
            let action = SettingsAction(title: "Privacy Policy", handler: { [weak self] in
                self?.open(url)
            })
            section.actions.append(action)
        }
        if let url = PurchaseKit.shared.configuration.termsOfServiceURL {
            let action = SettingsAction(title: "Terms of Use", handler: { [weak self] in
                self?.open(url)
            })
            section.actions.append(action)
        }
        return section
    }

    private func showContactUsFlow(email: String) {
        output?.settingsModuleDidRequestContact(self, email: email)
    }

    private func showRestorePurchasesFlow() {
        output?.settingsModuleDidRequestRestore(self)
    }

    private func showShareAppFlow(identifier: String) {
        output?.settingsModuleDidRequestShareApp(self, identifier: identifier)
    }

    private func open(_ url: URL) {
        output?.settingsModuleDidRequestOpen(self, url: url)
    }
}

// MARK: - SettingsViewOutput

extension SettingsPresenter: SettingsViewOutput {
    func premiumEventTriggered() {
        guard let identifier = state.premiumPaywallIdentifier else {
            return
        }

        output?.settingsModuleDidRequestPaywall(self, identifier: identifier)
    }

    func dismissEventTriggered() {
        output?.settingsModuleDidRequestDismiss(self)
    }
}

// MARK: - SettingsModuleInput

extension SettingsPresenter: SettingsModuleInput {
    //
}

// MARK: - SettingsViewModelDelegate

extension SettingsPresenter: SettingsViewModelDelegate {

    func makeAppVersion() -> String {
        return Bundle.main.appVersion
    }
}
