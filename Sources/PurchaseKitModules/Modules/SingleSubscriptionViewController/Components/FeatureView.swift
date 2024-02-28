//
//  File.swift
//  
//
//  Created by Anton Kormakov on 28.02.2024.
//

import UIKit
import LumaKit

final class FeatureView: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var circleView: UIView!
    @IBOutlet weak var emojiLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!

    private let feature: SingleSubscriptionPage.Feature
    private let colorScheme: ColorScheme

    init(feature: SingleSubscriptionPage.Feature, colorScheme: ColorScheme) {
        self.feature = feature
        self.colorScheme = colorScheme
        super.init(frame: .zero)

        Bundle.module.loadNibNamed("FeatureView", owner: self)
        addSubview(contentView)
        contentView.bindMarginsToSuperview()

        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        circleView.backgroundColor = colorScheme.background.primary
        circleView.layer.borderColor = colorScheme.genericAction.inactive.cgColor
        circleView.layer.borderWidth = 1.0

        emojiLabel.font = .systemFont(ofSize: 11.0)
        emojiLabel.text = feature.emoji

        titleLabel.textColor = colorScheme.foreground.primary
        titleLabel.font = .systemFont(ofSize: 14.0, weight: .semibold)
        titleLabel.configure(with: feature.title)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        circleView.layer.applyMaximumCornerRadius()
    }
}
