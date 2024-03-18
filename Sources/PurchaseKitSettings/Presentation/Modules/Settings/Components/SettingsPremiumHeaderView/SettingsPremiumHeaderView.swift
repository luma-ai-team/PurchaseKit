//
//  File.swift
//  
//
//  Created by Anton Kormakov on 14.03.2024.
//

import UIKit
import LumaKit
import AVFoundation

protocol SettingsPremiumHeaderViewDelegate: AnyObject {
    func settingsPremiumHeaderDidRequestAction(_ sender: SettingsPremiumHeaderView)
}

final class SettingsPremiumHeaderView: UITableViewHeaderFooterView {
    static var reuseIdentifier: String = "SettingsPremiumHeaderView"
    static var nib: UINib {
        return .init(nibName: reuseIdentifier, bundle: .module)
    }

    weak var delegate: SettingsPremiumHeaderViewDelegate?

    private lazy var playerLooper: PlayerLooper = .init(url: .dummy)
    @IBOutlet weak var playerView: PlayerView!
    @IBOutlet weak var gradientView: GradientView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var actionButton: ShimmerButton!

    override func layoutSubviews() {
        super.layoutSubviews()
        actionButton.applyMaximumCornerRadius()
    }

    func update(viewModel: PremiumHeaderViewModel, isSubscribed: Bool, colorScheme: ColorScheme) {
        if let url = viewModel.assetURL {
            playerLooper.url = url
        }
        playerView.backgroundColor = colorScheme.background.primary
        playerView.player = playerLooper.player
        playerLooper.play()

        gradientView.gradient = .vertical(colors: [colorScheme.background.primary.withAlphaComponent(0.25),
                                                   colorScheme.background.primary])

        titleLabel.text = viewModel.title
        titleLabel.textColor = colorScheme.foreground.primary
        titleLabel.isHidden = isSubscribed

        actionButton.gradient = colorScheme.gradient.primary
        actionButton.titleLabel?.font = .roundedSystemFont(ofSize: 20.0, weight: .bold)
        actionButton.setTitle(viewModel.action, for: .normal)
        actionButton.setTitleColor(colorScheme.premiumAction.active, for: .normal)
        actionButton.isHidden = isSubscribed
    }

    @IBAction func actionButtonPressed(_ sender: UIButton) {
        delegate?.settingsPremiumHeaderDidRequestAction(self)
    }
}
