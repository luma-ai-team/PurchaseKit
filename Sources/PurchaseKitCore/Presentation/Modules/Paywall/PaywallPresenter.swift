//
//  Copyright © 2023 Draftz. All rights reserved.
//

import UIKit
import GenericModule

public final class PaywallPresenter: Presenter<PaywallState,
                                               PaywallViewController,
                                               PaywallModuleInput,
                                               PaywallModuleOutput,
                                               PaywallModuleDependencies> {
    deinit {
        output?.paywallModuleDidFinish(self)
    }

    public override func viewDidLoad() {
        for submodule in state.submodules {
            let page = submodule.page
            state.userContent[page.identifier] = output?.paywallModuleDidRequestContent(self, for: page)
        }
        super.viewDidLoad()

        dependencies.storeService.fetchProducts(for: state.paywall) { [weak self] (products: [Product]) in
            guard let self = self else {
                return
            }

            self.state.isLoading = false
            self.state.products = products
            self.update(animated: true)
        } failure: { [weak self] (error: Error) in
            guard let self = self else {
                return
            }

            self.state.isProductFetchFailed = true
            if self.state.currentModule.hasProducts {
                self.output?.paywallModuleDidFinish(self)
            }
        }

        dependencies.analyitcsService.log(.paywallDisplayed(paywall: state.paywall))
        dependencies.analyitcsService.log(.pageDisplayed(for: state.paywall, index: state.moduleIndex))
    }
}

// MARK: - PaywallViewOutput

extension PaywallPresenter: PaywallViewOutput {
    //
}

// MARK: - PaywallModuleInput

extension PaywallPresenter: PaywallModuleInput {
    public func moduleDidRequestNextPage(_ page: Page) {
        let index = state.moduleIndex + 1
        guard state.submodules.indices.contains(index) else {
            output?.paywallModuleDidFinish(self)
            return
        }

        state.moduleIndex = index
        state.isLoading = state.submodules[state.moduleIndex].hasProducts && state.products.isEmpty
        if state.isLoading,
           state.isProductFetchFailed {
            output?.paywallModuleDidFinish(self)
        }
        else {
            dependencies.analyitcsService.log(.pageDisplayed(for: state.paywall, index: state.moduleIndex))
            update(animated: true)
        }
    }

    public func moduleDidRequestDismiss(_ page: Page) {
        output?.paywallModuleDidFinish(self)
    }

    public func moduleDidRequestPurchase(_ page: Page, product: Product) {
        state.isLoading = true
        update(animated: true)

        dependencies.analyitcsService.log(.purchaseStarted(for: state.paywall, product: product))
        dependencies.storeService.purchase(product, from: state.paywall, success: { [weak self] (_: Product) in
            guard let self = self else {
                return
            }

            self.state.isLoading = false
            self.output?.paywallModuleDidFinish(self)
            self.dependencies.analyitcsService.log(.purchaseCompleted(for: state.paywall, product: product))
        }, failure: { [weak self] (error: Error) in
            guard let self = self else {
                return
            }

            self.state.isLoading = false
            self.update(animated: true)
            self.output?.paywallModuleDidFail(self, with: error)
            self.dependencies.analyitcsService.log(.purchaseFailed(for: state.paywall, product: product, error: error))
        })
    }

    public func moduleDidRequestRestorePurchases(_ page: any Page) {
        state.isLoading = true
        update(animated: true)

        dependencies.storeService.restore(success: { [weak self] in
            guard let self = self else {
                return
            }

            if self.dependencies.storeService.isAnyProductPurchased {
                self.output?.paywallModuleDidFinish(self)
            }
            else {
                self.state.isLoading = false
                self.update(animated: true)
            }
        }, failure: { [weak self] (error: Error) in
            guard let self = self else {
                return
            }

            self.state.isLoading = false
            self.update(animated: true)
            self.output?.paywallModuleDidFail(self, with: error)
        })
    }

    public func moduleDidRequestPrivacyPolicy(_ page: any Page) {
        guard let url = state.configuration.privacyPolicyURL else {
            return
        }

        UIApplication.shared.open(url, completionHandler: nil)
    }

    public func moduleDidRequestTermsOfService(_ page: any Page) {
        guard let url = state.configuration.termsOfServiceURL else {
            return
        }

        UIApplication.shared.open(url, completionHandler: nil)
    }

    public func moduleDidRequestAppReview(_ page: Page) {
        guard let identifier = state.configuration.appStoreApplicationIdentifier,
              let url = URL.appStoreURL(withIdentifier: identifier, openReviewPage: true) else {
            return
        }

        UIApplication.shared.open(url)
    }
}

// MARK: - PaywallViewModelDelegate

extension PaywallPresenter: PaywallViewModelDelegate {
    //
}
