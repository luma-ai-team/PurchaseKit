//
//  File.swift
//  
//
//  Created by Anton Kormakov on 14.03.2024.
//

import UIKit
import LumaKit

final class SettingsTitleHeaderView: UITableViewHeaderFooterView {
    static var reuseIdentifier: String = "SettingsTitleHeaderView"

    override func layoutSubviews() {
        super.layoutSubviews()
        textLabel?.frame.origin.x = 0.0
    }

    func update(title: String, colorScheme: ColorScheme) {
        textLabel?.text = title
        textLabel?.textColor = colorScheme.foreground.secondary
    }
}
