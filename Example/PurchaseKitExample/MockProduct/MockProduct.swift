//
//  MockProduct.swift
//  PurchaseKitExample
//
//  Created by Anton Kormakov on 04.03.2024.
//

import Foundation
import StoreKit

final class MockSubscriptionPeriod: SKProductSubscriptionPeriod {
    override var unit: SKProduct.PeriodUnit {
        return mockUnit
    }

    override var numberOfUnits: Int {
        return mockNumberOfUnits
    }

    let mockUnit: SKProduct.PeriodUnit
    let mockNumberOfUnits: Int

    init(unit: SKProduct.PeriodUnit, count: Int) {
        mockUnit = unit
        mockNumberOfUnits = count
    }
}

final class MockProductDiscount: SKProductDiscount {
    override var price: NSDecimalNumber {
        return 0.0
    }

    override var priceLocale: Locale {
        return .current
    }

    override var subscriptionPeriod: SKProductSubscriptionPeriod {
        return mockDuration
    }

    override var paymentMode: SKProductDiscount.PaymentMode {
        return mockPaymentMode
    }

    let mockPaymentMode: SKProductDiscount.PaymentMode
    let mockDuration: MockSubscriptionPeriod

    init(paymentMode: SKProductDiscount.PaymentMode = .freeTrial, duration: MockSubscriptionPeriod) {
        mockPaymentMode = paymentMode
        mockDuration = duration
    }
}

final class MockProduct: SKProduct {
    override var productIdentifier: String {
        return "pk.product.mock"
    }

    override var price: NSDecimalNumber {
        return mockPrice
    }

    override var priceLocale: Locale {
        return .current
    }

    override var subscriptionPeriod: SKProductSubscriptionPeriod? {
        return mockDuration
    }

    override var introductoryPrice: SKProductDiscount? {
        return mockIntroductoryOffer
    }

    let mockPrice: NSDecimalNumber
    let mockDuration: MockSubscriptionPeriod
    let mockIntroductoryOffer: MockProductDiscount?

    init(price: NSDecimalNumber,
         duration: MockSubscriptionPeriod,
         introductoryOffer: MockProductDiscount? = nil) {
        mockPrice = price
        mockDuration = duration
        mockIntroductoryOffer = introductoryOffer
        super.init()
    }
}
