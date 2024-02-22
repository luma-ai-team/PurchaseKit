//
//  PaywallBuilder.swift
//  
//
//  Created by Anton Kormakov on 18.10.2023.
//

import Foundation

public final class PaywallBuilder {

    final class PageWrapper: Decodable {
        enum CodingKeys: CodingKey {
            case type
        }

        let type: String
    }

    final class PaywallWrapper: Decodable {
        enum PaywallWrapperError: Error {
            case unknownModuleType(String)
        }

        enum ContextKey {
            static var identifier: CodingUserInfoKey! = .init(rawValue: "identifier")
            static var moduleTypes: CodingUserInfoKey! = .init(rawValue: "moduleTypes")
        }

        let paywall: Paywall
        init(from decoder: Decoder) throws {
            let moduleTypes = decoder.userInfo[ContextKey.moduleTypes] as? [String: any PurchaseKitModule.Type]
            let container = try decoder.container(keyedBy: Paywall.CodingKeys.self)

            let identifier: String
            if let contextIdentifier = decoder.userInfo[ContextKey.identifier] as? String {
                identifier = contextIdentifier
            }
            else {
                identifier = try container.decode(String.self, forKey: .identifier)
            }

            let presentationStyle = try container.decodeIfPresent(PresentationStyle.self,
                                                                  forKey: .presentationStyle) ?? .init()

            var pageContainer = try container.nestedUnkeyedContainer(forKey: .pages)
            var pages: [any Page] = []

            var decodeContainer = pageContainer
            while pageContainer.isAtEnd == false {
                let pageWrapperContainer = try pageContainer.nestedContainer(keyedBy: PageWrapper.CodingKeys.self)
                let pageType = try pageWrapperContainer.decode(String.self, forKey: .type)
                guard let moduleType = moduleTypes?[pageType] else {
                    throw PaywallWrapperError.unknownModuleType(pageType)
                }

                let page = try moduleType.makePage(using: &decodeContainer)
                pages.append(page)
            }

            self.paywall = .init(identifier: identifier, presentationStyle: presentationStyle, pages: pages)
        }
    }

    private(set) var moduleTypes: [String: any PurchaseKitModule.Type] = [:]

    public func register(_ moduleType: any PurchaseKitModule.Type) {
        moduleTypes[moduleType.type] = moduleType
    }

    public func makePaywall(from data: Data, identifier: String? = nil) throws -> Paywall {
        let decoder = JSONDecoder()
        decoder.userInfo = [
            PaywallWrapper.ContextKey.identifier: identifier as Any,
            PaywallWrapper.ContextKey.moduleTypes: moduleTypes,
        ]
        let wrapper = try decoder.decode(PaywallWrapper.self, from: data)
        return wrapper.paywall
    }
}
