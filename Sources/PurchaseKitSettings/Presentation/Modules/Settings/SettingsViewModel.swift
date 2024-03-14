//
//  Copyright © 2024 . All rights reserved.
//


import GenericModule

protocol SettingsViewModelDelegate: AnyObject {
    var state: SettingsState { get }

    func makeAppVersion() -> String
}

final class SettingsViewModel: ViewModel {
    let sections: [SettingsSection]
    let version: String

    init(delegate: SettingsViewModelDelegate) {
        sections = delegate.state.sections
        version = delegate.makeAppVersion()
    }
}
