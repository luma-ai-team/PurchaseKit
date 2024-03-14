//
//  Copyright © 2024 . All rights reserved.
//

import Foundation
import GenericModule

public protocol SettingsModuleInput: AnyObject {
    func update(force: Bool, animated: Bool)
}

public protocol SettingsModuleOutput {
    func settingsModuleDidRequestContact(_ sender: SettingsModuleInput, email: String)
    func settingsModuleDidRequestShareApp(_ sender: SettingsModuleInput, identifier: String)
    func settingsModuleDidRequestOpen(_ sender: SettingsModuleInput, url: URL)

    func settingsModuleDidRequestPaywall(_ sender: SettingsModuleInput, identifier: String)
    func settingsModuleDidRequestRestore(_ sender: SettingsModuleInput)

    func settingsModuleDidRequestDismiss(_ sender: SettingsModuleInput)
}

typealias SettingsModuleDependencies = Any

final class SettingsModule: Module<SettingsPresenter> {
    //
}
