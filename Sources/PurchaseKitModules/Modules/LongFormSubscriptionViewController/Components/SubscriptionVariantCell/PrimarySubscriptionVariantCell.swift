//
//  File.swift
//  
//
//  Created by Anton Kormakov on 06.03.2024.
//

import UIKit
import LumaKit
import PurchaseKitCore

struct PrimarySubscriptionVariantViewModel: Equatable {
    let product: Product
    let discount: Int?
    let marker: String?
    let colorScheme: ColorScheme

    static func == (lhs: PrimarySubscriptionVariantViewModel,
                    rhs: PrimarySubscriptionVariantViewModel) -> Bool {
        return lhs.product == rhs.product
    }
}

final class PrimarySubscriptionVariantCell: UICollectionViewCell, CollectionViewCell {
    typealias ViewModel = PrimarySubscriptionVariantViewModel

    @IBOutlet weak var selectionView: GradientView!
    @IBOutlet weak var shapeView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var separatorView: UIView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var discountGradientView: GradientView!
    @IBOutlet weak var discountLabel: UILabel!
    @IBOutlet weak var markerLabel: UILabel!

    var colorScheme: ColorScheme = .init()

    override var isSelected: Bool {
        didSet {
            updateSelectionState()
        }
    }

    static func size(with viewModel: PrimarySubscriptionVariantViewModel, fitting size: CGSize, insets: UIEdgeInsets) -> CGSize {
        return .init(width: 105.0, height: 144.0)
    }

    static func register(in collectionView: UICollectionView, withIdentifier identifier: String) {
        collectionView.register(.init(nibName: "PrimarySubscriptionVariantCell", bundle: .module),
                                forCellWithReuseIdentifier: identifier)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionView.applyCornerRadius(value: 15.0)
        shapeView.applyCornerRadius(value: 12.0)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        discountGradientView.applyMaximumCornerRadius()
    }

    func update(with viewModel: PrimarySubscriptionVariantViewModel, attributes: CollectionViewCellAttributes) {
        colorScheme = viewModel.colorScheme
        selectionView.gradient = viewModel.colorScheme.gradient.primary
        shapeView.backgroundColor = viewModel.colorScheme.background.secondary

        titleLabel.text = viewModel.product.duration?.intervalString

        discountGradientView.isHidden = viewModel.discount == nil
        discountGradientView.gradient = viewModel.colorScheme.gradient.primary
        discountLabel.text = "Save \(viewModel.discount ?? 0)%"

        priceLabel.text = viewModel.product.price.string

        markerLabel.isHidden = viewModel.marker == nil
        markerLabel.text = viewModel.marker

        updateSelectionState()
    }

    private func updateSelectionState() {
        let color = isSelected ? colorScheme.foreground.primary : colorScheme.foreground.secondary
        titleLabel.textColor = color
        priceLabel.textColor = color
        markerLabel.textColor = color

        separatorView.backgroundColor = isSelected ?
            colorScheme.foreground.secondary :
            colorScheme.background.primary

        selectionView.isHidden = isSelected == false
    }
}
