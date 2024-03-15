//
//  VideoUserContent.swift
//
//
//  Created by Anton Kormakov on 18.10.2023.
//

import UIKit
import AVFoundation
import PurchaseKitCore

final public class VideoUserContent: UIView, UserContent {

    override public static var layerClass: AnyClass {
        return AVPlayerLayer.self
    }

    var observer: NSObjectProtocol?
    public private(set) lazy var player: AVPlayer = .init()

    public weak var playerLayer: AVPlayerLayer? {
        return layer as? AVPlayerLayer
    }

    public var aspectRatio: CGFloat {
        guard let asset = player.currentItem?.asset,
              let track = asset.tracks(withMediaType: AVMediaType.video).first else {
            return 1
        }
        let size = track.naturalSize.applying(track.preferredTransform)
        return abs(size.width) / abs(size.height)
    }

    public var contentView: UIView {
        return self
    }

    public init(playerItem: AVPlayerItem) {
        super.init(frame: .zero)
        player.replaceCurrentItem(with: playerItem)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(playerDidPlayToEndTime),
                                               name: .AVPlayerItemDidPlayToEndTime,
                                               object: playerItem)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
        stop()
    }

    public func start() {
        player.play()
    }

    public func stop() {
        player.replaceCurrentItem(with: nil)
    }

    // MARK: - Actions

    @objc private func playerDidPlayToEndTime() {
        player.seek(to: .zero)
        player.play()
    }
}
