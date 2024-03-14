//
//  File.swift
//  
//
//  Created by Anton Kormakov on 14.03.2024.
//

import UIKit
import LumaKit

final class SettingsActionCell: UITableViewCell {
    static var reuseIdentifier: String = "SettingsActionCell"
    static var nib: UINib {
        return .init(nibName: reuseIdentifier, bundle: .module)
    }

    @IBOutlet weak var titleLabel: UILabel!

    func update(with action: SettingsAction, colorScheme: ColorScheme) {
        backgroundColor = colorScheme.background.secondary

        titleLabel.text = action.title
        titleLabel.textColor = colorScheme.foreground.primary
    }
}
