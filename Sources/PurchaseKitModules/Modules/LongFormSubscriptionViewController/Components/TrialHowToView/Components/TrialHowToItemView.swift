//
//  File.swift
//  
//
//  Created by Anton Kormakov on 06.03.2024.
//

import UIKit
import LumaKit

final class TrialHowToItemView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var emojiLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!

    let mainColor: UIColor
    let emoji: String
    let title: String
    let subtitle: String
    let colorScheme: ColorScheme

    init(mainColor: UIColor, emoji: String, title: String, subtitle: String, colorScheme: ColorScheme) {
        self.mainColor = mainColor
        self.emoji = emoji
        self.title = title
        self.subtitle = subtitle
        self.colorScheme = colorScheme
        super.init(frame: .zero)

        Bundle.module.loadNibNamed("TrialHowToItemView", owner: self)
        addSubview(contentView)
        contentView.bindMarginsToSuperview()

        setup()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    private func setup() {
        colorView.backgroundColor = mainColor
        colorView.applyCornerRadius(value: 10.0)

        emojiLabel.text = emoji

        titleLabel.textColor = colorScheme.foreground.primary
        titleLabel.text = title

        subtitleLabel.textColor = colorScheme.foreground.secondary
        subtitleLabel.text = subtitle
    }
}
