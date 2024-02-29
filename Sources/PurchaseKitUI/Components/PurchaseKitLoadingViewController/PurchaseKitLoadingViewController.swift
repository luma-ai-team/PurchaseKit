//
//  File.swift
//  
//
//  Created by Anton Kormakov on 22.02.2024.
//

import UIKit
import LumaKit

public final class PurchaseKitLoadingViewController: UIViewController {

    @IBOutlet weak var progressView: GradientProgressView!

    public override var prefersStatusBarHidden: Bool {
        return true
    }

    public let colorScheme: ColorScheme

    public init(colorScheme: ColorScheme) {
        self.colorScheme = colorScheme
        super.init(nibName: "PurchaseKitLoadingViewController", bundle: .module)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = colorScheme.background.secondary
        progressView.backgroundColor = colorScheme.background.primary
        progressView.gradient = colorScheme.gradient.primary
    }

    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.progressView.setProgress(progress: 1.0, animation: .spring(duration: 5.0))
        }
    }
}
