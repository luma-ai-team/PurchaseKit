//
//  File.swift
//  
//
//  Created by Anton Kormakov on 25.10.2023.
//

import Foundation

public protocol HasAnalyticsService {
    var analyitcsService: AnalyticsService { get }
}

public protocol AnalyticsService: AnyObject {
    func log(_ event: AnalyticsEvent)
}
