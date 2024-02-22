//
//  DummyPaywallService.swift
//  
//
//  Created by Anton Kormakov on 18.10.2023.
//

import Foundation

public final class DummyPaywallService: PaywallService {
    public let data: Data

    public init(data: Data) {
        self.data = data
    }

    public init(url: URL) throws {
        self.data = try Data(contentsOf: url)
    }

    public func fetch(identifier: String, builder: PaywallBuilder, success: (Paywall) -> Void, failure: (Error) -> Void) {
        do {
            let paywall = try builder.makePaywall(from: data)
            success(paywall)
        }
        catch {
            failure(error)
        }
    }
}
