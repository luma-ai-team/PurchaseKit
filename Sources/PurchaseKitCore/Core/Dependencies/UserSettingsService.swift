//
//  File.swift
//  
//
//  Created by Anton Kormakov on 21.02.2024.
//

import Foundation

public protocol HasUserSettingsService {
    var userSettingsService: UserSettingsService { get }
}

public protocol UserSettingsService: AnyObject {
    var userIdentifier: String { get }
    
    var isOnboardingCompleted: Bool { get set }
    var premiumEventTriggerCount: Int { get set }
}
