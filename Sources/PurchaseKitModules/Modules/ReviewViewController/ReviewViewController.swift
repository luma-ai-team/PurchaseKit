import UIKit
import StoreKit
import PurchaseKitCore
import PurchaseKitUI
import GenericModule
import LumaKit
import Lottie

public class ReviewViewController: UIViewController, PurchaseKitModule, PurchaseKitScreen {
    public typealias PageType = ReviewPage

    public var viewModel: PurchaseKitScreenViewModel<ReviewPage>
    public weak var output: PurchaseKitModuleOutput?

    public override var prefersStatusBarHidden: Bool {
        return true
    }

    @IBOutlet weak var bottomGradientView: GradientView!
    @IBOutlet weak var topGradientView: GradientView!

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!

    @IBOutlet weak var lottieAnimationView: LottieAnimationView!
    @IBOutlet weak var reviewStarsView: ReviewStarsView!
    @IBOutlet weak var ratingLabel: UILabel!
    
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
        bottomGradientView.gradient = .vertical(colors: [
            viewModel.colorScheme.background.primary.withAlphaComponent(0.0),
            viewModel.colorScheme.background.primary.withAlphaComponent(0.5)
        ])
        topGradientView.gradient = .vertical(colors: [
            viewModel.colorScheme.background.primary.withAlphaComponent(1.0),
            viewModel.colorScheme.background.primary.withAlphaComponent(0.0)
        ])

        titleLabel.textColor = viewModel.colorScheme.foreground.primary
        titleLabel.font = .systemFont(ofSize: 32.0, weight: .heavy)
        titleLabel.configure(with: viewModel.page.title)

        subtitleLabel.textColor = viewModel.colorScheme.foreground.secondary
        subtitleLabel.font = .systemFont(ofSize: 14.0, weight: .medium)
        subtitleLabel.configure(with: viewModel.page.subtitle)
        subtitleLabel.isHidden = viewModel.page.hasProducts

        lottieAnimationView.animation = .asset("lottie-review-anim", bundle: .module)
        lottieAnimationView.contentMode = .scaleAspectFill
        lottieAnimationView.loopMode = .loop

        reviewStarsView.backgroundColor = viewModel.colorScheme.background.secondary
        reviewStarsView.applyShadow(color: viewModel.colorScheme.genericAction.active)
        reviewStarsView.rating = viewModel.page.rating

        ratingLabel.textColor = viewModel.colorScheme.foreground.primary
        ratingLabel.text = "\(viewModel.page.rating)/5 Stars Reviews"

        actionButton.gradient = viewModel.colorScheme.gradient.primary
        actionButton.tintColor = viewModel.colorScheme.premiumAction.active
        actionButton.configure(with: viewModel.page.action)
    }

    public func screenWillAppear() {
        titleLabel.alpha = 0.0
        subtitleLabel.alpha = 0.0
        lottieAnimationView.alpha = 0.0
        reviewStarsView.alpha = 0.0
        ratingLabel.alpha = 0.0
        actionButton.alpha = 0.0

        actionButton.isUserInteractionEnabled = true
        DispatchQueue.main.async {
            UIView.defaultSpringAnimation(duration: 1.0, delay: 0.3, animations: {
                self.titleLabel.alpha = 1.0
            })
            UIView.defaultSpringAnimation(duration: 1.0, delay: 0.5, animations: {
                self.subtitleLabel.alpha = 1.0
            })
            UIView.defaultSpringAnimation(duration: 1.0, delay: 0.7, animations: {
                self.lottieAnimationView.play()
                self.lottieAnimationView.alpha = 1.0
            })
            UIView.defaultSpringAnimation(duration: 1.0, delay: 0.9, animations: {
                self.reviewStarsView.alpha = 1.0
                self.ratingLabel.alpha = 1.0
            })
            UIView.defaultSpringAnimation(duration: 1.0, delay: 1.1, options: [.allowUserInteraction], animations: {
                self.actionButton.alpha = 1.0
            })
        }
    }

    public func screenDidDisappear() {
        lottieAnimationView.stop()
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

    @IBAction func actionButtonPressed(_ sender: UIButton) {
        actionButton.startLoading()

        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            SKStoreReviewController.requestReview(in: scene)
        }
        else {
            SKStoreReviewController.requestReview()
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.output?.moduleDidRequestNextPage(self.viewModel.page)
        }
    }
}
