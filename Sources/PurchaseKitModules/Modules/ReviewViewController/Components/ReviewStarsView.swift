//
//  File.swift
//  
//
//  Created by Anton Kormakov on 29.02.2024.
//

import UIKit

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

    private lazy var emptyImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .center
        view.image = UIImage(named: "imgStarsEmpty", in: .module, with: nil)
        return view
    }()

    private lazy var filledMaskView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()

    private lazy var filledImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .center
        view.image = UIImage(named: "imgStarsFilled", in: .module, with: nil)
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
        addSubview(backgroundFillView)
        addSubview(emptyImageView)
        addSubview(filledImageView)
        applyShadow(opacity: 0.1)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        backgroundFillView.frame = bounds
        backgroundFillView.layer.cornerRadius = 12.0

        emptyImageView.sizeToFit()
        emptyImageView.center = bounds.center

        filledImageView.sizeToFit()
        filledImageView.center = bounds.center

        let fill = CGFloat(rating / 5.0)
        filledMaskView.frame = .init(x: 0.0,
                                     y: 0.0,
                                     width: fill * filledImageView.bounds.width,
                                     height: filledImageView.bounds.height)
    }
}
