import UIKit
import StoreKit
import PurchaseKitCore
import PurchaseKitUI
import GenericModule
import LumaKit

public class ReviewViewController: UIViewController, PurchaseKitModule, PurchaseKitScreen {
    public typealias PageType = ReviewPage

    public var viewModel: PurchaseKitScreenViewModel<ReviewPage>
    public weak var output: PurchaseKitModuleOutput?

    public override var prefersStatusBarHidden: Bool {
        return true
    }

    @IBOutlet weak var gradientView: GradientView!

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!

    @IBOutlet weak var usersImageView: UIImageView!
    @IBOutlet weak var plusImageView: UIImageView!
    
    @IBOutlet weak var reviewButton: BounceButton!
    @IBOutlet weak var actionButton: ActionButton!

    public required init(viewModel: PurchaseKitScreenViewModel<ReviewPage>, output: PurchaseKitModuleOutput?) {
        self.viewModel = viewModel
        self.output = output
        super.init(nibName: "ReviewViewController", bundle: .module)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = viewModel.colorScheme.background.primary
        gradientView.gradient = .vertical(colors: [
            viewModel.colorScheme.genericAction.active.withAlphaComponent(0.25),
            viewModel.colorScheme.genericAction.active.withAlphaComponent(0.0)
        ])

        titleLabel.textColor = viewModel.colorScheme.foreground.primary
        titleLabel.font = .systemFont(ofSize: 24.0, weight: .semibold)
        titleLabel.configure(with: viewModel.page.title)

        subtitleLabel.textColor = viewModel.colorScheme.foreground.secondary
        subtitleLabel.font = .systemFont(ofSize: 14.0, weight: .semibold)
        subtitleLabel.configure(with: viewModel.page.subtitle)
        subtitleLabel.isHidden = viewModel.page.hasProducts

        let configuration = UIImage.SymbolConfiguration(pointSize: 12.0, weight: .semibold)
        plusImageView.image = .init(systemName: "plus", withConfiguration: configuration)
        plusImageView.tintColor = viewModel.colorScheme.genericAction.active
        plusImageView.backgroundColor = viewModel.colorScheme.background.secondary

        reviewButton.backgroundColor = viewModel.colorScheme.background.secondary
        reviewButton.tintColor = viewModel.colorScheme.genericAction.active
        reviewButton.applyCornerRadius(value: 12.0)
        reviewButton.applyShadow(opacity: 0.1)

        actionButton.gradient = viewModel.colorScheme.gradient.primary
        actionButton.tintColor = viewModel.colorScheme.premiumAction.active
        actionButton.configure(with: viewModel.page.action)
    }

    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        plusImageView.applyMaximumCornerRadius()
    }

    public func screenWillAppear() {
        titleLabel.alpha = 0.0
        subtitleLabel.alpha = 0.0
        usersImageView.alpha = 0.0
        plusImageView.alpha = 0.0
        reviewButton.alpha = 0.0
        actionButton.alpha = 0.0

        actionButton.startLoading()
        actionButton.isUserInteractionEnabled = true
        DispatchQueue.main.async {
            UIView.defaultSpringAnimation(duration: 1.0, delay: 0.3, animations: {
                self.titleLabel.alpha = 1.0
            })
            UIView.defaultSpringAnimation(duration: 1.0, delay: 0.5, animations: {
                self.subtitleLabel.alpha = 1.0
            })
            UIView.defaultSpringAnimation(duration: 1.0, delay: 0.7, animations: {
                self.usersImageView.alpha = 1.0
                self.plusImageView.alpha = 1.0
            })
            UIView.defaultSpringAnimation(duration: 1.0, delay: 0.9, animations: {
                self.reviewButton.alpha = 1.0
            })
            UIView.defaultSpringAnimation(duration: 1.0, delay: 1.1, options: [.allowUserInteraction], animations: {
                self.actionButton.alpha = 1.0
            })
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                SKStoreReviewController.requestReview(in: scene)
            }
            else {
                SKStoreReviewController.requestReview()
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.actionButton.stopLoading()
        }
    }

    public func screenDidDisappear() {
        actionButton.isUserInteractionEnabled = false
    }

    public func update(with viewModel: PurchaseKitScreenViewModel<ReviewPage>, force: Bool, animated: Bool) {
        let viewUpdate = Update(newModel: viewModel, oldModel: self.viewModel, force: force)
        self.viewModel = viewModel
        update(with: viewUpdate, animated: animated)
    }

    func update(with viewUpdate: Update<PurchaseKitScreenViewModel<ReviewPage>>, animated: Bool) {
        //
    }

    // MARK: - Actions

    @IBAction func reviewButtonPressed(_ sender: Any) {
        output?.moduleDidRequestAppReview(viewModel.page)
    }

    @IBAction func actionButtonPressed(_ sender: UIButton) {
        output?.moduleDidRequestNextPage(viewModel.page)
    }
}
