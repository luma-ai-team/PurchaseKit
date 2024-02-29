//
//  File.swift
//
//
//  Created by Anton Kormakov on 29.02.2024.
//

import UIKit
import LumaKit

public final class PurchaseKitRestoreViewController: UIViewController {

    private lazy var activityIndicatorView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .medium)
        view.color = colorScheme.foreground.primary
        return view
    }()

    let colorScheme: ColorScheme
    public init(colorScheme: ColorScheme) {
        self.colorScheme = colorScheme
        super.init(nibName: nil, bundle: nil)
        setup()
    }

    required init?(coder: NSCoder) {
        colorScheme = .init()
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        modalTransitionStyle = .crossDissolve
        modalPresentationStyle = .overCurrentContext
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = colorScheme.background.primary.withAlphaComponent(0.5)
        view.addSubview(activityIndicatorView)

        activityIndicatorView.startAnimating()
    }

    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        activityIndicatorView.frame = view.bounds
    }
}
