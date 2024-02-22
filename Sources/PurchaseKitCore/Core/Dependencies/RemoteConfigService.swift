//
//  RemoteConfigService.swift
//  
//
//  Created by Anton Kormakov on 19.10.2023.
//

import Foundation

public protocol HasRemoteConfigService {
    var remoteConfigService: any RemoteConfigService { get }
}

public protocol RemoteConfigService {
    associatedtype Config: RemoteConfig

    var remoteConfig: Config { get }

    func fetch(success: @escaping (Config) -> Void, failure: @escaping (Error) -> Void)
}
