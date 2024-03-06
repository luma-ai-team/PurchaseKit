//
//  File.swift
//  
//
//  Created by Anton Kormakov on 06.03.2024.
//

import UIKit
import LumaKit
import PurchaseKitCore

struct SecondarySubscriptionVariantViewModel: Equatable {
    let product: Product
    let colorScheme: ColorScheme

    static func == (lhs: SecondarySubscriptionVariantViewModel,
                    rhs: SecondarySubscriptionVariantViewModel) -> Bool {
        return lhs.product == rhs.product
    }
}

final class SecondarySubscriptionVariantCell: UICollectionViewCell, CollectionViewCell {
    typealias ViewModel = SecondarySubscriptionVariantViewModel

    @IBOutlet weak var selectionView: GradientView!
    @IBOutlet weak var shapeView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var separatorView: UIView!
    @IBOutlet weak var priceLabel: UILabel!

    var colorScheme: ColorScheme = .init()

    override var isSelected: Bool {
        didSet {
            updateSelectionState()
        }
    }

    static func size(with viewModel: SecondarySubscriptionVariantViewModel,
                     fitting size: CGSize,
                     insets: UIEdgeInsets) -> CGSize {
        return .init(width: 105.0, height: 144.0)
    }

    static func register(in collectionView: UICollectionView, withIdentifier identifier: String) {
        collectionView.register(.init(nibName: "SecondarySubscriptionVariantCell", bundle: .module),
                                forCellWithReuseIdentifier: identifier)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionView.applyCornerRadius(value: 15.0)
        shapeView.applyCornerRadius(value: 12.0)
    }

    func update(with viewModel: SecondarySubscriptionVariantViewModel, attributes: CollectionViewCellAttributes) {
        colorScheme = viewModel.colorScheme
        selectionView.gradient = viewModel.colorScheme.gradient.primary
        shapeView.backgroundColor = viewModel.colorScheme.background.secondary

        titleLabel.text = viewModel.product.duration?.intervalString
        priceLabel.text = viewModel.product.price.string

        updateSelectionState()
    }

    private func updateSelectionState() {
        let color = isSelected ? colorScheme.foreground.primary : colorScheme.foreground.secondary
        titleLabel.textColor = color
        priceLabel.textColor = color

        separatorView.backgroundColor = isSelected ?
            colorScheme.foreground.secondary :
            colorScheme.background.primary

        selectionView.isHidden = isSelected == false
    }
}
