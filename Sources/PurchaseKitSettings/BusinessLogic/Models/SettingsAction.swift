//
//  SettingsAction.swift
//
//
//  Created by Anton Kormakov on 13.03.2024.
//

import Foundation

final class SettingsAction {
    let title: String
    let handler: () -> Void

    init(title: String, handler: @escaping () -> Void) {
        self.title = title
        self.handler = handler
    }
}

extension SettingsAction: Equatable {
    static func == (lhs: SettingsAction, rhs: SettingsAction) -> Bool {
        return lhs.title == rhs.title
    }
}
