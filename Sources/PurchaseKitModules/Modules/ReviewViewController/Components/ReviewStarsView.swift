//
//  File.swift
//  
//
//  Created by Anton Kormakov on 29.02.2024.
//

import UIKit

final class StarView: UIView {

    var progress: Float = 0.0 {
        didSet {
            layout()
        }
    }

    private lazy var emptyImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "icStarEmpty", in: .module, with: nil)
        view.contentMode = .center
        return view
    }()

    private lazy var filledMaskView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()

    private lazy var filledImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "icStarFilled", in: .module, with: nil)
        view.contentMode = .center
        view.mask = filledMaskView
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        addSubview(emptyImageView)
        addSubview(filledImageView)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        emptyImageView.frame = bounds
        filledImageView.frame = bounds

        filledMaskView.frame = .init(x: 0.0,
                                     y: 0.0,
                                     width: CGFloat(progress) * filledImageView.bounds.width,
                                     height: filledImageView.bounds.height)
    }

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        return .init(width: 26.0, height: 26.0)
    }
}

final class ReviewStarsView: UIView {

    var rating: Float = 4.5 {
        didSet {
            layout()
        }
    }

    override var backgroundColor: UIColor? {
        didSet {
            backgroundFillView.backgroundColor = backgroundColor
            super.backgroundColor = .clear
        }
    }

    private lazy var backgroundFillView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        return view
    }()

    private lazy var starViews: [StarView] = (0..<5).map { (index: Int) in
        let view = StarView()
        view.tag = index
        return view
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        addSubview(backgroundFillView)
        for view in starViews {
            addSubview(view)
        }
        applyShadow(opacity: 0.1)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        backgroundFillView.frame = bounds
        backgroundFillView.layer.cornerRadius = 12.0

        let spacing: CGFloat = 10.0
        let middleIndex = starViews.count / 2
        let middleStarView = starViews[middleIndex]
        middleStarView.sizeToFit()
        middleStarView.center = bounds.center

        var offset: CGFloat = middleStarView.frame.maxX + spacing
        for view in starViews[(middleIndex + 1)...] {
            view.sizeToFit()
            view.center = .init(x: offset + view.bounds.midX, y: bounds.midY)
            offset = view.frame.maxX + spacing
        }

        offset = middleStarView.frame.minX - spacing
        for view in starViews[0..<middleIndex].reversed() {
            view.sizeToFit()
            view.center = .init(x: offset - view.bounds.midX, y: bounds.midY)
            offset = view.frame.minX - spacing
        }

        for (index, view) in starViews.enumerated() {
            view.progress = (rating - Float(index)).clamped(min: 0.0, max: 1.0)
        }
    }
}
