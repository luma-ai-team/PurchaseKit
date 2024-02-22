//
//
//

import UIKit

public protocol UserContent {
    var aspectRatio: CGFloat { get }
    var contentView: UIView { get }

    func start()
    func stop()
}
