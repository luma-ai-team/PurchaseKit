//
//  File.swift
//  
//
//  Created by Anton Kormakov on 05.03.2024.
//

import UIKit
import PurchaseKitCore
import PurchaseKitUI
import GenericModule
import LumaKit

final class LongFormSubscriptionViewController: UIViewController, PurchaseKitModule, PurchaseKitScreen {
    public typealias PageType = LongFormSubscriptionPage

    public var viewModel: PurchaseKitScreenViewModel<PageType>
    public weak var output: PurchaseKitCore.PurchaseKitModuleOutput?

    public override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBOutlet weak var dismissButton: BounceButton!
    
    private lazy var playerLooper: PlayerLooper = .init(url: .root)
    @IBOutlet weak var playerView: PlayerView!
    @IBOutlet weak var userContentContainerView: UIView!
    @IBOutlet weak var gradientView: GradientView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    @IBOutlet weak var featuresContainerView: UIView!
    @IBOutlet weak var featuresTitleLabel: UILabel!
    @IBOutlet weak var featuresStackView: UIStackView!

    @IBOutlet weak var variantsContainerView: UIView!
    @IBOutlet weak var trialToggleContainerView: UIView!
    @IBOutlet weak var trialLabel: UILabel!
    @IBOutlet weak var trialSwitch: UISwitch!

    @IBOutlet weak var variantsCollectionView: UICollectionView!
    private lazy var variantsCollectionViewManager: CollectionViewManager = .init(collectionView: variantsCollectionView)

    @IBOutlet weak var trialHowToContainerView: UIView!
    private lazy var trialHowToView: TrialHowToView = {
        return TrialHowToView(trialDayCount: 3, colorScheme: viewModel.colorScheme)
    }()

    @IBOutlet weak var testimonialsContainerView: UIView!

    @IBOutlet weak var actionContainerView: UIView!
    @IBOutlet weak var subscriptionTermsLabel: UILabel!
    @IBOutlet weak var actionButton: ActionButton!
    @IBOutlet weak var linksStackView: UIStackView!
    
    private var productPairs: [ProductPair] = []
    private var selectedProductPair: ProductPair? {
        didSet {
            updateVariantPicker()
            updateSubscriptionTerms()
        }
    }

    private var isEligibleForTrial: Bool {
        return selectedProductPair?.alternativeProduct != nil
    }

    public required init(viewModel: PurchaseKitScreenViewModel<PageType>, output: PurchaseKitModuleOutput?) {
        self.viewModel = viewModel
        self.output = output
        super.init(nibName: "LongFormSubscriptionViewController", bundle: .module)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = viewModel.colorScheme.background.primary

        if let asset = viewModel.page.asset,
           let url = Bundle.main.url(forResource: asset, withExtension: nil) {
            playerLooper.url = url
            playerView.player = playerLooper.player
        }

        gradientView.gradient = .vertical(colors: [viewModel.colorScheme.background.primary.withAlphaComponent(0.0),
                                                   viewModel.colorScheme.background.primary.withAlphaComponent(0.75),
                                                   viewModel.colorScheme.background.primary])
        actionContainerView.backgroundColor = viewModel.colorScheme.background.secondary.withAlphaComponent(0.95)

        titleLabel.textColor = viewModel.colorScheme.foreground.primary
        titleLabel.font = .systemFont(ofSize: 30.0, weight: .semibold)
        titleLabel.configure(with: viewModel.page.title)

        subtitleLabel.textColor = viewModel.colorScheme.foreground.secondary
        subtitleLabel.font = .systemFont(ofSize: 15.0, weight: .semibold)
        subtitleLabel.configure(with: viewModel.page.subtitle)

        actionContainerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        actionContainerView.applyCornerRadius(value: 24.0)

        actionButton.titleLabel?.numberOfLines = 0
        actionButton.gradient = viewModel.colorScheme.gradient.primary
        actionButton.tintColor = viewModel.colorScheme.premiumAction.active
        actionButton.configure(with: viewModel.page.action)

        featuresTitleLabel.textColor = viewModel.colorScheme.foreground.primary
        for feature in viewModel.page.features {
            let view = LongFormFeatureView(feature: feature, colorScheme: viewModel.colorScheme)
            featuresStackView.addArrangedSubview(view)
        }

        updateVariantPicker()

        testimonialsContainerView.isHidden = viewModel.page.testimonials.isEmpty
        let testimonialsView = TestimonialsView(testimonials: viewModel.page.testimonials,
                                                colorScheme: viewModel.colorScheme)
        testimonialsContainerView.addSubview(testimonialsView)
        testimonialsView.bindMarginsToSuperview()

        trialHowToContainerView.addSubview(trialHowToView)
        trialHowToView.bindMarginsToSuperview()

        updateDismissButton()
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

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        variantsCollectionView.layoutIfNeeded()
        variantsCollectionView.contentInset.left = 0.5 * (variantsCollectionView.bounds.width - variantsCollectionView.contentSize.width)
        variantsCollectionView.contentInset.right = variantsCollectionView.contentInset.left
    }

    public func screenWillAppear() {
        playerLooper.play()
        dismissButton.animateIn(with: viewModel.page.closeAction)
        linksStackView.animateIn(with: viewModel.page.closeAction)

        let animationViews: [UIView] = [
            titleLabel,
            subtitleLabel,
            featuresContainerView,
            variantsContainerView,
            trialHowToContainerView,
            testimonialsContainerView
        ]
        animationViews.animateCascadeSpring(fromAlpha: 0.0, toAlpha: 1.0, delay: 0.3, completion: {})
    }

    public func screenDidDisappear() {
        //
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
            var pendingProducts = products
            productPairs.removeAll()

            let baseProducts = pendingProducts.filter { (product: Product) in
                return product.introductoryOffer == nil
            }

            for baseProduct in baseProducts {
                let pair = ProductPair(baseProduct: baseProduct,
                                       alternativeProduct: products.first(where: { (product: Product) in
                    return (product.duration == baseProduct.duration) && (product.introductoryOffer != nil)
                }))

                pendingProducts.removeAll(matching: baseProduct)
                if let alternativeProduct = pair.alternativeProduct {
                    pendingProducts.removeAll(matching: alternativeProduct)
                }

                productPairs.append(pair)
            }

            for leftoverProduct in pendingProducts {
                let pair = ProductPair(baseProduct: leftoverProduct, alternativeProduct: nil)
                productPairs.append(pair)
            }

            productPairs = productPairs.sorted(by: \.duration.dayDuration)
            productPairs = Array(productPairs.prefix(3))
            if selectedProductPair == nil {
                selectedProductPair = productPairs[safe: productPairs.count - 2] ?? productPairs.first
            }

            updateVariantPicker()
        }
    }

    private func updateVariantPicker() {
        variantsContainerView.isHidden = viewModel.content.products.isEmpty

        trialToggleContainerView.applyCornerRadius(value: 12.0)
        trialToggleContainerView.isHidden = isEligibleForTrial == false
        trialHowToContainerView.isHidden = isEligibleForTrial == false

        if let selectedProductPair = selectedProductPair,
           let product = selectedProductPair.alternativeProduct,
           let offer = product.introductoryOffer {
            trialLabel.text = "Enable \(product.durationString(for: offer.duration, isPluralized: false)) free trial"
            trialHowToView.trialDayCount = offer.duration.dayDuration
        }
        trialSwitch.onTintColor = viewModel.colorScheme.genericAction.active
        variantsCollectionView.isHidden = productPairs.count < 2

        if productPairs.count == 3 {
            let firstCellItem = makeSecondaryVariantCellItem(atIndex: 0)
            let secondCellItem = makePrimaryVariantCellItem(atIndex: 1, marker: "Best Value")
            let thirdCellItem = makeSecondaryVariantCellItem(atIndex: 2)
            let section = BasicCollectionViewSection(items: [firstCellItem, secondCellItem, thirdCellItem])
            variantsCollectionViewManager.sections = [section]
        }
        else {
            let cellItems = productPairs.indices.map { (index: Array<ProductPair>.Index) in
                return makePrimaryVariantCellItem(atIndex: index, marker: nil)
            }
            let section = BasicCollectionViewSection(items: cellItems)
            variantsCollectionViewManager.sections = [section]
        }

        if let index = productPairs.firstIndexWithReference(to: selectedProductPair) {
            variantsCollectionViewManager.select(.init(item: index, section: 0))
        }

        view.setNeedsLayout()
    }

    private func makePrimaryVariantCellItem(atIndex index: Int, marker: String?) -> any CollectionViewItem {
        var discount: Int?
        if marker != nil,
           let referenceProductPair = productPairs.sorted(by: \.baseProduct.referencePrice.floatValue).last {
            let referencePrice = referenceProductPair.baseProduct.referencePrice.floatValue
            discount = Int(100.0 * (1.0 - productPairs[index].baseProduct.referencePrice.floatValue / referencePrice))
        }

        let viewModel = PrimarySubscriptionVariantViewModel(product: productPairs[index].baseProduct,
                                                            discount: discount,
                                                            marker: marker,
                                                            colorScheme: viewModel.colorScheme)
        let cellItem = BasicCollectionViewItem<PrimarySubscriptionVariantCell>(viewModel: viewModel)
        cellItem.selectionHandler = { [weak self] _ in
            self?.selectedProductPair = self?.productPairs[index]
        }
        return cellItem
    }

    private func makeSecondaryVariantCellItem(atIndex index: Int) -> any CollectionViewItem {
        let viewModel = SecondarySubscriptionVariantViewModel(product: productPairs[index].baseProduct,
                                                                          colorScheme: viewModel.colorScheme)
        let cellItem = BasicCollectionViewItem<SecondarySubscriptionVariantCell>(viewModel: viewModel)
        cellItem.selectionHandler = { [weak self] _ in
            self?.selectedProductPair = self?.productPairs[index]
        }
        return cellItem
    }

    private func updateSubscriptionTerms() {
        guard let selectedProductPair = selectedProductPair else {
            return
        }

        let introductoryOffer: Product.IntroductoryOffer?
        let product: Product
        if let alternativeProduct = selectedProductPair.alternativeProduct,
           trialSwitch.isOn {
            product = alternativeProduct
            introductoryOffer = alternativeProduct.introductoryOffer
        }
        else {
            product = selectedProductPair.baseProduct
            introductoryOffer = selectedProductPair.baseProduct.introductoryOffer
        }

        let priceString: String = "\(product.price.string) a \(product.subscriptionUnitString ?? .init())"
        if let offer = introductoryOffer {
            let durationString = product.durationString(for: offer.duration, isPluralized: false, isCapitalized: true)
            let offerString = "\(durationString) Free Trial - then"
            subscriptionTermsLabel.text = "\(offerString) \(priceString).\nCancel anytime."
        }
        else {
            subscriptionTermsLabel.text = "\(priceString).\nCancel anytime."
        }

        subscriptionTermsLabel.textColor = viewModel.colorScheme.foreground.secondary

        if let action = viewModel.page.action {
            actionButton.configure(with: action, product: product)
        }
        else if introductoryOffer?.price.value == 0.0 {
            actionButton.setTitle("Try For Free", for: .normal)
        }
        else {
            actionButton.setTitle("Continue", for: .normal)
        }
    }

    // MARK: - Actions

    @IBAction func trialSwitchValueChanged(_ sender: UISwitch) {
        updateVariantPicker()
        updateSubscriptionTerms()
    }
    
    @IBAction func actionButtonPressed(_ sender: UIButton) {
        guard let selectedProductPair = selectedProductPair else {
            output?.moduleDidRequestNextPage(viewModel.page)
            return
        }

        let product: Product
        if let alternativeProduct = selectedProductPair.alternativeProduct,
           trialSwitch.isOn {
            product = alternativeProduct
        }
        else {
            product = selectedProductPair.baseProduct
        }

        output?.moduleDidRequestPurchase(viewModel.page, product: product)
    }

    @IBAction func privacyPolicyButtonPressed(_ sender: UIButton) {
        output?.moduleDidRequestPrivacyPolicy(viewModel.page)
    }

    @IBAction func termsOfUseButtonPressed(_ sender: UIButton) {
        output?.moduleDidRequestTermsOfService(viewModel.page)
    }

    @IBAction func restorePurchasesButtonPressed(_ sender: UIButton) {
        output?.moduleDidRequestRestorePurchases(viewModel.page)
    }

    @IBAction func dismissButtonPressed(_ sender: UIButton) {
        output?.moduleDidRequestDismiss(viewModel.page)
    }
}
