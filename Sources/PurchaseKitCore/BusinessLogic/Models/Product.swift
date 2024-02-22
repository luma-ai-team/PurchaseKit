//
//  Product.swift
//
//  Created by Anton Kormakov on 18.10.2023.
//

import Foundation
import StoreKit

public final class Product {
    public class Price {
        public let value: NSDecimalNumber
        public let locale: Locale
        public let string: String

        public var currencySymbol: String {
            return locale.currencySymbol ?? .init()
        }

        public init(value: NSDecimalNumber, locale: Locale) {
            self.value = value
            self.locale = locale
            self.string = value.localizedPrice(for: locale)
        }
    }

    public enum Duration: Equatable {
        case years(Int)
        case months(Int)
        case weeks(Int)
        case days(Int)
        case unknown

        init(period: SKProductSubscriptionPeriod) {
            switch period.unit {
            case .year:
                self = .years(period.numberOfUnits)
            case .month:
                self = .months(period.numberOfUnits)
            case .week:
                self = .weeks(period.numberOfUnits)
            case .day:
                self = .days(period.numberOfUnits)
            @unknown default:
                self = .unknown
            }
        }
    }

    public final class IntroductoryOffer {
        public let price: Price
        public let duration: Duration

        public init(price: Price, duration: Duration) {
            self.price = price
            self.duration = duration
        }
    }

    public let identifier: String
    public let skProduct: SKProduct

    public let title: String
    public let info: String

    public let price: Price
    public internal(set) var duration: Duration? = nil
    public internal(set) var introductoryOffer: IntroductoryOffer? = nil

    public init(product: SKProduct) {
        self.identifier = product.productIdentifier
        self.skProduct = product

        title = product.localizedTitle
        info = product.localizedDescription

        price = .init(value: product.price, locale: product.priceLocale)
        if let period = product.subscriptionPeriod {
            self.duration = .init(period: period)
        }

        if let introductoryOffer = product.introductoryPrice {
            self.introductoryOffer = .init(price: .init(value: introductoryOffer.price, locale: introductoryOffer.priceLocale),
                                           duration: .init(period: introductoryOffer.subscriptionPeriod))
        }
    }
}

// MARK: - Equatable

extension Product: Equatable {
    public static func == (lhs: Product, rhs: Product) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}
