//
//  File.swift
//  
//
//  Created by Stas Klyukhin on 20.05.2022.
//

import Foundation
import PurchaseKitCore

public extension TextElement {
    enum Constants {
        static let offerMark: String = "%fullPrice%"

        static let priceMark: String = "%price%"
        static let durationMark: String = "%duration%"
        static let durationUnitMark: String = "%durationUnit%"

        static let introductoryPriceMark: String = "%introPrice%"
        static let introductoryDurationMark: String = "%introDuration%"
        static let introductoryDurationUnitMark: String = "%introDurationUnit%"
    }

    func makeFormattedText(for product: Product) -> String? {
        var result = text
        result = result?.replacingOccurrences(of: Constants.priceMark, with: product.price.string)
        result = result?.replacingOccurrences(of: Constants.durationMark,
                                              with: product.subscriptionDurationString ?? .init())
        result = result?.replacingOccurrences(of: Constants.durationUnitMark,
                                              with: product.subscriptionUnitString ?? .init())
        result = result?.replacingOccurrences(of: Constants.introductoryPriceMark,
                                              with: product.introductoryOffer?.price.string ?? .init())
        result = result?.replacingOccurrences(of: Constants.introductoryDurationMark,
                                              with: product.introductoryOfferDurationString ?? .init())
        result = result?.replacingOccurrences(of: Constants.introductoryDurationUnitMark,
                                              with: product.introductoryOfferUnitString ?? .init())
        result = result?.replacingOccurrences(of: Constants.offerMark, with: product.offerDescription)
        return result
    }
}
