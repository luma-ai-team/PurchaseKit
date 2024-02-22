//
//  DummyRemoteConfigService.swift
//  
//
//  Created by Anton Kormakov on 19.10.2023.
//

import Foundation

open class DummyRemoteConfigService: RemoteConfigService {
    public typealias Config = DefaultRemoteConfig

    public var remoteConfig: DefaultRemoteConfig

    public required init(fallback: DefaultRemoteConfig) {
        self.remoteConfig = fallback
    }

    public func fetch(success: (DefaultRemoteConfig) -> Void, failure: (Error) -> Void) {
        success(remoteConfig)
    }
}
