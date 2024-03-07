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

    var unitDescription: String {
        switch unit {
        case .day:
            return "day"
        case .week:
            return "week"
        case .month:
            return "month"
        case .year:
            return "year"
        @unknown default:
            return "surprise"
        }
    }

    private let mockUnit: SKProduct.PeriodUnit
    private let mockNumberOfUnits: Int

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

    private let mockPaymentMode: SKProductDiscount.PaymentMode
    let mockDuration: MockSubscriptionPeriod

    init(paymentMode: SKProductDiscount.PaymentMode = .freeTrial, duration: MockSubscriptionPeriod) {
        mockPaymentMode = paymentMode
        mockDuration = duration
    }
}

final class MockProduct: SKProduct {
    override var productIdentifier: String {
        var identifier: String = "pk.product.mock"
        identifier.append("/price:\(price.floatValue)")
        identifier.append("/duration:\(mockDuration.unitDescription)-\(mockDuration.numberOfUnits)")
        if let offer = mockIntroductoryOffer {
            identifier.append("/trial:\(offer.mockDuration.unitDescription)-\(offer.subscriptionPeriod.numberOfUnits)")
        }
        return identifier
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

    private let mockPrice: NSDecimalNumber
    private let mockDuration: MockSubscriptionPeriod
    private let mockIntroductoryOffer: MockProductDiscount?

    init(price: NSDecimalNumber,
         duration: MockSubscriptionPeriod,
         introductoryOffer: MockProductDiscount? = nil) {
        mockPrice = price
        mockDuration = duration
        mockIntroductoryOffer = introductoryOffer
        super.init()
    }
}
