//
//  File.swift
//  
//
//  Created by Anton Kormakov on 21.02.2024.
//

import UIKit
import LumaKit

open class ActionButton: ShimmerButton {

    open override var tintColor: UIColor! {
        didSet {
            activityIndicatorView.color = tintColor
            arrowImageView.tintColor = tintColor
            titleLabel?.textColor = tintColor
        }
    }

    private lazy var arrowImageView: UIImageView = {
        let view = UIImageView()
        let configuration = UIImage.SymbolConfiguration(pointSize: 24.0, weight: .semibold)
        view.image = UIImage(systemName: "arrow.forward", withConfiguration: configuration)
        return view
    }()

    private lazy var activityIndicatorView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .medium)
        view.hidesWhenStopped = true
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        bounceStyle = .none
        titleLabel?.font = .roundedSystemFont(ofSize: 24.0, weight: .semibold)
        addSubview(arrowImageView)
        addSubview(activityIndicatorView)
    }

    open override func layoutSubviews() {
        super.layoutSubviews()

        layer.cornerRadius = bounds.midY
        titleLabel?.frame.origin.x = 24.0
        titleLabel?.isHidden = activityIndicatorView.isAnimating

        activityIndicatorView.frame = bounds

        arrowImageView.sizeToFit()
        arrowImageView.center = .init(x: bounds.width - arrowImageView.bounds.midX - 21.0, y: bounds.midY)
        arrowImageView.isHidden = activityIndicatorView.isAnimating
        startArrowAnimation()
    }

    public func startLoading() {
        isUserInteractionEnabled = false
        activityIndicatorView.startAnimating()
        layout()
    }

    public func stopLoading() {
        isUserInteractionEnabled = true
        activityIndicatorView.stopAnimating()
        layout()
    }

    private func startArrowAnimation() {
        arrowImageView.layer.removeAllAnimations()

        let animation = CABasicAnimation(keyPath: "transform.translation.x")
        animation.fromValue = -4.0
        animation.toValue = 4.0
        animation.autoreverses = true
        animation.timingFunction = CAMediaTimingFunction(name: .linear)
        animation.duration = 0.75
        animation.repeatCount = .infinity
        animation.isRemovedOnCompletion = false
        arrowImageView.layer.add(animation, forKey: animation.keyPath)
    }
}
