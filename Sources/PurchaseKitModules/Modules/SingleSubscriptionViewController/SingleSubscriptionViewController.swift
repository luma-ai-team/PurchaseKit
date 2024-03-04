
import UIKit
import AVFoundation
import PurchaseKitCore
import PurchaseKitUI
import GenericModule
import LumaKit

public class SingleSubscriptionViewController: UIViewController, PurchaseKitModule, PurchaseKitScreen {
    public typealias PageType = SingleSubscriptionPage

    public var viewModel: PurchaseKitScreenViewModel<PageType>
    public weak var output: PurchaseKitCore.PurchaseKitModuleOutput?

    public override var prefersStatusBarHidden: Bool {
        return true
    }

    private lazy var playerLooper: PlayerLooper = .init(url: .root)
    @IBOutlet weak var playerView: PlayerView!
    @IBOutlet weak var gradientView: GradientView!
    
    @IBOutlet weak var userContentContainerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!

    @IBOutlet weak var actionContainerView: UIView!
    @IBOutlet weak var actionButton: ActionButton!
    @IBOutlet weak var featureStackView: UIStackView!
    
    @IBOutlet weak var linksStackView: UIStackView!
    @IBOutlet weak var privacyPolicyButton: UIButton!
    @IBOutlet weak var termsOfUseButton: UIButton!
    @IBOutlet weak var restorePurchasesButton: UIButton!

    @IBOutlet weak var dismissButton: BounceButton!

    public required init(viewModel: PurchaseKitScreenViewModel<PageType>, output: PurchaseKitModuleOutput?) {
        self.viewModel = viewModel
        self.output = output
        super.init(nibName: "SingleSubscriptionViewController", bundle: .module)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        if let asset = viewModel.page.asset,
           let url = Bundle.main.url(forResource: asset, withExtension: nil) {
            playerLooper.url = url
            playerView.player = playerLooper.player
        }

        view.backgroundColor = viewModel.colorScheme.background.secondary
        gradientView.gradient = .vertical(colors: [viewModel.colorScheme.background.secondary.withAlphaComponent(0.0),
                                                   viewModel.colorScheme.background.secondary.withAlphaComponent(0.75),
                                                   viewModel.colorScheme.background.secondary])
        actionContainerView.backgroundColor = viewModel.colorScheme.background.secondary

        titleLabel.textColor = viewModel.colorScheme.foreground.primary
        titleLabel.font = .systemFont(ofSize: 32.0, weight: .semibold)
        titleLabel.configure(with: viewModel.page.title)

        subtitleLabel.textColor = viewModel.colorScheme.foreground.secondary
        subtitleLabel.font = .systemFont(ofSize: 16.0, weight: .semibold)
        subtitleLabel.configure(with: viewModel.page.subtitle)
        subtitleLabel.isHidden = viewModel.page.hasProducts

        actionButton.titleLabel?.numberOfLines = 0
        actionButton.gradient = viewModel.colorScheme.gradient.primary
        actionButton.tintColor = viewModel.colorScheme.premiumAction.active
        actionButton.configure(with: viewModel.page.action)

        for feature in viewModel.page.features {
            let view = FeatureView(feature: feature, colorScheme: viewModel.colorScheme)
            featureStackView.addArrangedSubview(view)
        }

        privacyPolicyButton.tintColor = viewModel.colorScheme.foreground.primary.withAlphaComponent(0.7)
        termsOfUseButton.tintColor = viewModel.colorScheme.foreground.primary.withAlphaComponent(0.7)
        restorePurchasesButton.tintColor = viewModel.colorScheme.foreground.primary.withAlphaComponent(0.7)

        updateDismissButton()
        linksStackView.isHidden = viewModel.page.hasProducts == false
    }

    private func updateDismissButton() {
        var buttonConfiguration: UIButton.Configuration = .plain()
        buttonConfiguration.contentInsets = .init(top: 16, leading: 16, bottom: 16, trailing: 16)
        dismissButton.configuration = buttonConfiguration

        let colorConfiguration = UIImage.SymbolConfiguration(paletteColors: [
            viewModel.colorScheme.background.primary.withAlphaComponent(0.81),
            viewModel.colorScheme.foreground.primary.withAlphaComponent(0.14)
        ])
        let fontConfiguration = UIImage.SymbolConfiguration(pointSize: 20, weight: .medium)
        let symbolConfiguration = fontConfiguration.applying(colorConfiguration)

        let image = UIImage(systemName: "xmark.circle.fill", withConfiguration: symbolConfiguration)
        dismissButton.setImage(image, for: .normal)

        dismissButton.isHidden = viewModel.page.closeAction != nil
        dismissButton.configure(with: viewModel.page.closeAction)
    }

    public func screenWillAppear() {
        playerLooper.play()
        dismissButton.animateIn(with: viewModel.page.closeAction)
        linksStackView.animateIn(with: viewModel.page.closeAction)

        titleLabel.alpha = 0.0
        subtitleLabel.alpha = 0.0
        actionButton.alpha = 0.0
        linksStackView.alpha = 0.0

        for featureView in featureStackView.arrangedSubviews {
            featureView.alpha = 0.0
        }

        viewModel.content.userContent?.start()
        actionButton.isUserInteractionEnabled = true
        DispatchQueue.main.async {
            UIView.defaultSpringAnimation(duration: 1.0, delay: 0.3, animations: {
                self.titleLabel.alpha = 1.0
            })
            UIView.defaultSpringAnimation(duration: 1.0, delay: 0.5, animations: {
                self.subtitleLabel.alpha = 1.0
            })

            var delay: TimeInterval = 0.7
            for featureView in self.featureStackView.arrangedSubviews {
                UIView.defaultSpringAnimation(duration: 1.0, delay: delay, animations: {
                    featureView.alpha = 1.0
                })
                delay += 0.2
            }

            UIView.defaultSpringAnimation(duration: 1.0, delay: delay, options: [.allowUserInteraction], animations: {
                self.actionButton.alpha = 1.0
            })

            if self.viewModel.page.closeAction == nil {
                UIView.defaultSpringAnimation(duration: 1.0, 
                                              delay: delay + 0.2,
                                              options: [.allowUserInteraction],
                                              animations: {
                    self.linksStackView.alpha = 1.0
                })
            }
        }
    }

    public func screenDidDisappear() {
        viewModel.content.userContent?.stop()
        actionButton.isUserInteractionEnabled = false
        playerLooper.stop()
    }

    public func update(with viewModel: PurchaseKitScreenViewModel<PageType>, force: Bool, animated: Bool) {
        let viewUpdate = Update(newModel: viewModel, oldModel: self.viewModel, force: force)
        self.viewModel = viewModel
        update(with: viewUpdate, animated: animated)

        if let content = viewModel.content.userContent {
            userContentContainerView.addSubview(content.contentView)
            content.contentView.bindMarginsToSuperview()
        }
    }

    func update(with viewUpdate: Update<PurchaseKitScreenViewModel<PageType>>, animated: Bool) {
        viewUpdate(\.content.products) { (products: [Product]) in
            guard let product = products.first else {
                return
            }
            
            subtitleLabel.isHidden = false
            subtitleLabel.configure(with: viewModel.page.subtitle, product: product)

            if let action = viewModel.page.action {
                actionButton.configure(with: action, product: product)
            }
            else if product.introductoryOffer?.price.value == 0.0 {
                actionButton.setTitle("Try For Free", for: .normal)
            }
            else {
                actionButton.setTitle("Continue", for: .normal)
            }
        }
    }

    // MARK: - Actions

    @IBAction func privacyPolicyButtonPressed(_ sender: UIButton) {
        output?.moduleDidRequestPrivacyPolicy(viewModel.page)
    }
    
    @IBAction func termsOfUseButtonPressed(_ sender: UIButton) {
        output?.moduleDidRequestTermsOfService(viewModel.page)
    }
    
    @IBAction func restorePurchasesButtonPressed(_ sender: UIButton) {
        output?.moduleDidRequestRestorePurchases(viewModel.page)
    }

    @IBAction func dismissButtonPresssed(_ sender: UIButton) {
        output?.moduleDidRequestDismiss(viewModel.page)
    }
    
    @IBAction func actionButtonPressed(_ sender: UIButton) {
        if let product = viewModel.content.products.first {
            output?.moduleDidRequestPurchase(viewModel.page, product: product)
        }
        else {
            output?.moduleDidRequestNextPage(viewModel.page)
        }
    }
}
