//
//  Copyright © 2023 Draftz. All rights reserved.
//

import UIKit
import GenericModule

public protocol PaywallViewOutput: ViewOutput {
    //
}

public final class PaywallViewController: ViewController<PaywallViewModel, Any, PaywallViewOutput> {

    public enum Direction {
        case horizontal
        case vertical
    }

    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.isPagingEnabled = true
        view.isScrollEnabled = false
        return view
    }()

    private lazy var loadingView: LoadingView = .init()

    private var direction: Direction = .vertical

    public required init(viewModel: PaywallViewModel, output: PaywallViewOutput) {
        super.init(viewModel: viewModel, output: output)
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .crossDissolve
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    public override func viewDidLoad() {
        super.viewDidLoad {
            view.addSubview(scrollView)
            view.addSubview(loadingView)

            for module in viewModel.submodules {
                if let controller = module.screen as? UIViewController {
                    addChild(controller)
                }
                scrollView.addSubview(module.screen.view)
            }
        }
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.submodules[viewModel.pageIndex].screen.screenWillAppear()
    }

    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        scrollView.frame = view.bounds
        switch direction {
        case .horizontal:
            scrollView.contentSize = .init(width: view.bounds.width * CGFloat(viewModel.submodules.count),
                                           height: view.bounds.height)
        case .vertical:
            scrollView.contentSize = .init(width: view.bounds.width, height: view.bounds.height)
        }

        loadingView.frame = view.bounds

        var offset: CGFloat = 0.0
        for module in viewModel.submodules {
            switch direction {
            case .horizontal:
                module.screen.view.frame = .init(x: offset, y: 0.0, width: view.bounds.width, height: view.bounds.height)
                offset = module.screen.view.frame.maxX
            case .vertical:
                var targetOffset = offset - CGFloat(viewModel.pageIndex) * view.bounds.height
                if targetOffset < 0.0 {
                    targetOffset *= 0.5
                }

                module.screen.view.frame = .init(x: 0.0,
                                                 y: targetOffset,
                                                 width: view.bounds.width,
                                                 height: view.bounds.height)
                offset += module.screen.view.bounds.height
            }
        }
    }

    public override func update(with viewModel: PaywallViewModel, force: Bool, animated: Bool) {
        super.update(with: viewModel, force: force, animated: animated)

        for submodule in viewModel.submodules {
            let content = PurchaseKitScreenContent()
            content.userContent = viewModel.userContent[submodule.page.identifier]
            if submodule.hasProducts {
                content.products = viewModel.products
                content.isLoading = viewModel.isLoading
            }

            submodule.screen.update(with: content, force: force, animated: animated)
        }
    }

    public override func update(with viewUpdate: Update<ViewModel>, animated: Bool) {
        viewUpdate(\.pageIndex) { (index: Int) in
            if isVisible {
                viewModel.submodules[index].screen.screenWillAppear()
            }

            func animationCompletionHandler(_ isFinished: Bool) {
                for (moduleIndex, module) in self.viewModel.submodules.enumerated() where moduleIndex != index {
                    module.screen.screenDidDisappear()
                }
            }

            switch direction {
            case .horizontal:
                let offset = CGFloat(index) * view.bounds.width
                UIView.defaultSpringAnimation(duration: 0.75, animations: {
                    self.scrollView.setContentOffset(.init(x: offset, y: 0.0), animated: true)
                }, completion: animationCompletionHandler)
            case .vertical:
                UIView.defaultSpringAnimation(duration: 0.75, animations: {
                    self.view.layout()
                }, completion: animationCompletionHandler)
            }
        }

        viewUpdate(\.isLoading) { (isLoading: Bool) in
            loadingView.setHidden(isLoading == false, animated: animated)
        }
    }
}
