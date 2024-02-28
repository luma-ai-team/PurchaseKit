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

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        var configuration = PurchaseKitConfiguration()
        configuration.colorScheme.background = .init(primary: .init(rgb: 0xFFFFFF),
                                                     secondary: .init(rgb: 0xF2F2F7))
        configuration.colorScheme.genericAction = .init(active: .init(rgb: 0x4F83FF),
                                                        inactive: .init(rgb: 0xA8A8BF))
        configuration.colorScheme.gradient = .init(gradient: .horizontal(colors: [
            .init(rgb: 0x8F00FF),
            .init(rgb: 0x0057FF)
        ]))

        configuration.appStoreApplicationIdentifier = "1454542238"
        configuration.privacyPolicyURL = .init(string: "https://google.com")

//        let factory = AdaptyServiceFactory<DefaultRemoteConfig>(key: "public_live_QnCyopGl.ONWn4xULsvbDCV3z3EIT",
//                                                                remoteConfigFallback: .init())
//        factory.analyticsProxy = DummyAnalyticsService()

        let url: URL! = Bundle.main.url(forResource: "Paywall.json", withExtension: nil)
        let factory = try! DummyPurchaseKitServiceFactory(url: url)

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
        PurchaseKit.shared.present(identifier: "PKOnboarding", on: self, bindings: bindings, shouldWaitForProductFetch: false)
    }
}
