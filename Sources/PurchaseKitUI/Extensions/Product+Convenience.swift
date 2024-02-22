//
//  File.swift
//  
//
//  Created by Anton Kormakov on 20.10.2023.
//

import Foundation
import PurchaseKitCore

public extension Product {

    var subscriptionDurationString: String? {
        guard let duration = duration else {
            return nil
        }

        return self.durationString(for: duration)
    }

    var subscriptionUnitString: String? {
        guard let duration = duration else {
            return nil
        }

        return self.unitString(for: duration)
    }

    var introductoryOfferDurationString: String? {
        guard let duration = introductoryOffer?.duration else {
            return nil
        }

        return self.durationString(for: duration)
    }

    var introductoryOfferUnitString: String? {
        guard let duration = introductoryOffer?.duration else {
            return nil
        }

        return self.unitString(for: duration)
    }

    var offerDescription: String {
        guard let duration = duration else {
            return price.string
        }

        let introductoryOfferDescription: String = {
            guard let introductoryOffer = introductoryOffer else {
                return .init()
            }

            let introductoryOfferDuration = durationString(for: introductoryOffer.duration)
            var introductoryOfferSuffix: String {
                if introductoryOffer.price.value.decimalValue > 0 {
                    return "for \(introductoryOffer.price.currencySymbol)\(introductoryOffer.price.value)"
                } else {
                    return "for free"
                }

            }
            return "\(introductoryOfferDuration) \(introductoryOfferSuffix), then"
        }()

        let unit = unitString(for: duration)
        let subscriptionDescription = "\(price.currencySymbol)\(price.value)/\(unit)"
        if introductoryOfferDescription.isEmpty {
            return subscriptionDescription
        }

        return "\(introductoryOfferDescription) \(subscriptionDescription)"
    }

    func unitString(for duration: Product.Duration) -> String {
        switch duration {
        case .days(let count):
            return (count == 7) ? "week" : "day"
        case .weeks:
            return "week"
        case .months:
            return "month"
        case .years:
            return "year"
        case .unknown:
            return .init()
        }
    }

    func durationString(for duration: Product.Duration) -> String {
        if duration == .days(7) {
            return "1 week"
        }

        let numberOfUnits: Int
        switch duration {
        case .days(let count):
            numberOfUnits = count
        case .weeks(let count):
            numberOfUnits = count
        case .months(let count):
            numberOfUnits = count
        case .years(let count):
            numberOfUnits = count
        case .unknown:
            return .init()
        }

        let unit = unitString(for: duration)
        let suffix = (numberOfUnits > 1) ? "s" : .init()
        return "\(numberOfUnits) \(unit)\(suffix)"
    }
}
