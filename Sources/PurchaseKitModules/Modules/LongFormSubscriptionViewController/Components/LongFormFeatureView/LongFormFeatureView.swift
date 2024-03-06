//
//  File.swift
//  
//
//  Created by Anton Kormakov on 28.02.2024.
//

import UIKit
import LumaKit

final class LongFormFeatureView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var emojiContainerView: UIView!
    @IBOutlet weak var emojiLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!

    private let feature: LongFormSubscriptionPage.Feature
    private let colorScheme: ColorScheme

    init(feature: LongFormSubscriptionPage.Feature, colorScheme: ColorScheme) {
        self.feature = feature
        self.colorScheme = colorScheme
        super.init(frame: .zero)

        Bundle.module.loadNibNamed("LongFormFeatureView", owner: self)
        addSubview(contentView)
        contentView.bindMarginsToSuperview()

        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        emojiLabel.font = .systemFont(ofSize: 14.0)
        emojiLabel.text = feature.emoji

        titleLabel.textColor = colorScheme.foreground.secondary
        titleLabel.font = .systemFont(ofSize: 12.0, weight: .semibold)
        titleLabel.configure(with: feature.title)
    }
}
