//
//  File.swift
//  
//
//  Created by Anton Kormakov on 13.03.2024.
//

import Foundation

final class SettingsSection {
    enum Header: Equatable {
        case none
        case premium(PremiumHeaderViewModel, isSubscribed: Bool)
        case title(String)

        var height: CGFloat {
            switch self {
            case .none:
                return 0.0
            case .title:
                return 32.0
            case .premium:
                return 272.0
            }
        }
    }

    let header: Header
    var actions: [SettingsAction]

    init(header: Header, actions: [SettingsAction] = []) {
        self.header = header
        self.actions = actions
    }
}

extension SettingsSection: Equatable {
    static func == (lhs: SettingsSection, rhs: SettingsSection) -> Bool {
        return (lhs.header == rhs.header) &&
               (lhs.actions == rhs.actions)
    }
}
