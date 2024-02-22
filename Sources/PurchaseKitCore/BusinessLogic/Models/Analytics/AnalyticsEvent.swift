//
//  AnalyticsEvent.swift
//
//
//  Created by Anton Kormakov on 24.10.2023.
//

import Foundation

public class AnalyticsEvent {
    public let identifier: String
    public var parameters: [String: String]

    init(identifier: String, parameters: [String: String] = [:]) {
        self.identifier = identifier
        self.parameters = parameters
    }
}

public extension AnalyticsEvent {
    enum EventIdentifier: String {
        case paywallFetchFailed
        case paywallDisplayFailed
        case remoteConfigFetchFailed
        case productFetchFailed
        case paywallDisplayed
        case pageDisplayed
        case paywallDismissed
        case purchaseStarted
        case purchaseCompleted
        case purchaseFailed
    }

    enum EventParameter: String {
        case identifier
        case product
        case error
        case index
    }

    static func paywallFetchFailed(identifier: String, error: Error) -> AnalyticsEvent {
        return .init(identifier: EventIdentifier.paywallFetchFailed.rawValue, parameters: [
            EventParameter.identifier.rawValue: identifier,
            EventParameter.error.rawValue: "\(error)"
        ])
    }

    static func paywallDisplayFailed(identifier: String, error: Error) -> AnalyticsEvent {
        return .init(identifier: EventIdentifier.paywallDisplayFailed.rawValue, parameters: [
            EventParameter.identifier.rawValue: identifier,
            EventParameter.error.rawValue: "\(error)"
        ])
    }

    static func remoteConfigFetchFailed(identifier: String, error: Error) -> AnalyticsEvent {
        return .init(identifier: EventIdentifier.remoteConfigFetchFailed.rawValue, parameters: [
            EventParameter.identifier.rawValue: identifier,
            EventParameter.error.rawValue: "\(error)"
        ])
    }

    static func productFetchFailed(for paywall: Paywall, error: Error) -> AnalyticsEvent {
        return .init(identifier: EventIdentifier.productFetchFailed.rawValue, parameters: [
            EventParameter.identifier.rawValue: paywall.identifier,
            EventParameter.error.rawValue: "\(error)"
        ])
    }

    static func paywallDisplayed(paywall: Paywall) -> AnalyticsEvent {
        return .init(identifier: EventIdentifier.paywallDisplayed.rawValue, parameters: [
            EventParameter.identifier.rawValue: paywall.identifier
        ])
    }

    static func pageDisplayed(for paywall: Paywall, index: Int) -> AnalyticsEvent {
        return .init(identifier: EventIdentifier.pageDisplayed.rawValue, parameters: [
            EventParameter.identifier.rawValue: paywall.identifier,
            EventParameter.index.rawValue: "\(index)"
        ])
    }

    static func paywallDismissed(paywall: Paywall) -> AnalyticsEvent {
        return .init(identifier: EventIdentifier.paywallDismissed.rawValue, parameters: [
            EventParameter.identifier.rawValue: paywall.identifier
        ])
    }

    static func purchaseStarted(for paywall: Paywall, product: Product) -> AnalyticsEvent {
        return .init(identifier: EventIdentifier.purchaseStarted.rawValue, parameters: [
            EventParameter.identifier.rawValue: paywall.identifier,
            EventParameter.product.rawValue: product.identifier
        ])
    }

    static func purchaseFailed(for paywall: Paywall, product: Product, error: Error) -> AnalyticsEvent {
        return .init(identifier: EventIdentifier.purchaseFailed.rawValue, parameters: [
            EventParameter.identifier.rawValue: paywall.identifier,
            EventParameter.product.rawValue: product.identifier,
            EventParameter.error.rawValue: "\(error)"
        ])
    }

    static func purchaseCompleted(for paywall: Paywall, product: Product) -> AnalyticsEvent {
        return .init(identifier: EventIdentifier.purchaseCompleted.rawValue, parameters: [
            EventParameter.identifier.rawValue: paywall.identifier,
            EventParameter.product.rawValue: product.identifier
        ])
    }
}
