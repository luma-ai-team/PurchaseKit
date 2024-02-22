//
//  DummyAnalyticsService.swift
//  
//
//  Created by Anton Kormakov on 25.10.2023.
//

import Foundation

open class DummyAnalyticsService: AnalyticsService {
    public init() {}

    public func log(_ event: AnalyticsEvent) {
        print("Event: \(event.identifier) (\(event.parameters))")
    }
}
