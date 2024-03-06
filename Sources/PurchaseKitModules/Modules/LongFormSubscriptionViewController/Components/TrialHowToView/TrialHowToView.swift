//
//  File.swift
//  
//
//  Created by Anton Kormakov on 06.03.2024.
//

import UIKit
import LumaKit

final class TrialHowToView: UIView {
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var gradientLineView: GradientView!
    @IBOutlet weak var stackView: UIStackView!

    var trialDayCount: Int {
        didSet {
            updateStackView()
        }
    }

    let colorScheme: ColorScheme

    init(trialDayCount: Int, colorScheme: ColorScheme) {
        self.trialDayCount = trialDayCount
        self.colorScheme = colorScheme
        super.init(frame: .zero)

        Bundle.module.loadNibNamed("TrialHowToView", owner: self)
        addSubview(contentView)
        contentView.bindMarginsToSuperview()

        updateStackView()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    private func updateStackView() {
        var gradientLineColors = colorScheme.gradient.primary.colors
        if let terminalColor = gradientLineColors.last {
            gradientLineColors.append(terminalColor.withAlphaComponent(0.0))
        }
        gradientLineView.gradient = .vertical(colors: gradientLineColors)

        for view in stackView.arrangedSubviews {
            view.removeFromSuperview()
        }

        let todayItemView = TrialHowToItemView(mainColor: colorScheme.gradient.primary.color(atOffset: 0.0) ?? .clear,
                                               emoji: "🚀",
                                               title: "Today",
                                               subtitle: "Start your free trial today and unlock all features in app",
                                               colorScheme: colorScheme)
        stackView.addArrangedSubview(todayItemView)

        let reminderItemView = TrialHowToItemView(mainColor: colorScheme.gradient.primary.color(atOffset: 0.5) ?? .clear,
                                                  emoji: "🔔",
                                                  title: "Day \(trialDayCount - 1)",
                                                  subtitle: "We will send you a reminder that your trial ends soon",
                                                  colorScheme: colorScheme)
        stackView.addArrangedSubview(reminderItemView)

        let paymentItemView = TrialHowToItemView(mainColor: colorScheme.gradient.primary.color(atOffset: 1.0) ?? .clear,
                                                 emoji: "🪙",
                                                 title: "Day \(trialDayCount)",
                                                 subtitle: "You’ll be charged today, but you can cancel anytime before",
                                                 colorScheme: colorScheme)
        stackView.addArrangedSubview(paymentItemView)
    }
}
