//
//  LoadingView.swift
//  
//
//  Created by Anton Kormakov on 25.10.2023.
//

import UIKit

final class LoadingView: UIView {

    private lazy var activityIndicatorView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .medium)
        view.hidesWhenStopped = true
        view.color = .white
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
        backgroundColor = .black.withAlphaComponent(0.5)
        addSubview(activityIndicatorView)
        activityIndicatorView.startAnimating()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        activityIndicatorView.frame = bounds
    }
}
