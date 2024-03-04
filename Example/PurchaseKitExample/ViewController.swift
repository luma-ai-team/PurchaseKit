//
//  ViewController.swift
//  PurchaseKitExample
//
//  Created by Anton Kormakov on 18.10.2023.
//

import UIKit
import LumaKit
import PurchaseKitCore
import PurchaseKitAdapty
import PurchaseKitModules
import PurchaseKitUI

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let colorScheme: ColorScheme = .init()
        colorScheme.background = .init(primary: .p3(rgb: 0xF8F8FC),
                                       secondary: .p3(rgb: 0xFFFFFF))
        colorScheme.foreground = .init(primary: .p3(rgb: 0x000000),
                                       secondary: .p3(rgb: 0x8A8A8D))
        colorScheme.genericAction = .init(active: .p3(rgb: 0x232C64),
                                          inactive: .p3(rgb: 0xD2D5E7),
                                          disabled: .p3(rgb: 0xF0F0FF))
        colorScheme.premiumAction = .init(color: .white)
        colorScheme.destructiveAction = .init(color: .p3(rgb: 0xE53E3E))
        colorScheme.gradient = .init(gradient: .diagonalLTR(colors: [.p3(rgb: 0x338CFF), .p3(rgb: 0x33E7FF)]))

        var configuration = PurchaseKitConfiguration()
        configuration.colorScheme = colorScheme

        configuration.appStoreApplicationIdentifier = "1454542238"
        configuration.privacyPolicyURL = .init(string: "https://google.com")

//        let factory = AdaptyServiceFactory<DefaultRemoteConfig>(key: "public_live_QnCyopGl.ONWn4xULsvbDCV3z3EIT",
//                                                                remoteConfigFallback: .init())
//        factory.analyticsProxy = DummyAnalyticsService()

        let url: URL! = Bundle.main.url(forResource: "Paywall.json", withExtension: nil)
        let product = MockProduct(price: 9.99,
                                  duration: .init(unit: .week, count: 1),
                                  introductoryOffer: nil)
        let factory = try! DummyPurchaseKitServiceFactory(url: url,
                                                          products: [.init(product: product)])

        PurchaseKit.shared.registerDefaultModules()
        PurchaseKit.shared.start(with: configuration, dependencies: factory)
        DispatchQueue.main.async {
            self.showPaywall()
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        showPaywall()
    }

    func showPaywall() {
        let bindings: PaywallBindings = .init()
        bindings.userContentProvider = { (page: any Page) in
            return nil
        }
        bindings.completionHandler = {
            print("here")
        }
        PurchaseKit.shared.present(identifier: "PKOnboarding", 
                                   on: self,
                                   transitionStyle: .coverVertical,
                                   bindings: bindings,
                                   shouldWaitForProductFetch: false)
    }
}
