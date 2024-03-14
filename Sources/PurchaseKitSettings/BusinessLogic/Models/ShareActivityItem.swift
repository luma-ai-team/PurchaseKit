//
//  File.swift
//  
//
//  Created by Anton Kormakov on 14.03.2024.
//

import Foundation
import LinkPresentation
import LumaKit

class ShareAppAcitivtyItem: NSObject, UIActivityItemSource {
    let applicationIdentifier: String
    let displayName: String?

    init(applicationIdentifier: String, displayName: String?) {
        self.applicationIdentifier = applicationIdentifier
        self.displayName = displayName
    }

    func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        return ""
    }

    func activityViewController(_ activityViewController: UIActivityViewController, 
                                itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
        guard let url: URL = .appStoreURL(withIdentifier: applicationIdentifier) else {
            return nil
        }

        if activityType == .airDrop {
            return url
        }

        if let displayName = displayName {
            return "Download \(displayName) App for free: \(url.absoluteString)"
        }
        else {
            return "Download for free: \(url.absoluteString)"
        }
    }

    func activityViewController(_ activityViewController: UIActivityViewController, 
                                subjectForActivityType activityType: UIActivity.ActivityType?) -> String {
        return displayName ?? .init()
    }

    func activityViewControllerLinkMetadata(_ activityViewController: UIActivityViewController) -> LPLinkMetadata? {
        let metadata = LPLinkMetadata()
        metadata.title = displayName
        return metadata
    }
}
