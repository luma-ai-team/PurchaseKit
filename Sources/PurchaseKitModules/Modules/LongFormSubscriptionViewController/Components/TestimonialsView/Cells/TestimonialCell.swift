//
//  File.swift
//  
//
//  Created by Anton Kormakov on 06.03.2024.
//

import UIKit
import LumaKit

struct TestimonialViewModel: Equatable {
    let testimonial: LongFormSubscriptionPage.Testimonial
    let colorScheme: ColorScheme

    static func == (lhs: TestimonialViewModel, rhs: TestimonialViewModel) -> Bool {
        return lhs.testimonial == rhs.testimonial
    }
}

final class TestimonialCell: UICollectionViewCell, CollectionViewCell {
    typealias ViewModel = TestimonialViewModel

    @IBOutlet var starImageViews: [UIImageView]!
    @IBOutlet weak var messageLabel: UILabel!

    static func size(with viewModel: TestimonialViewModel,
                     fitting size: CGSize,
                     insets: UIEdgeInsets) -> CGSize {
        return .init(width: 149, height: 82)
    }

    static func register(in collectionView: UICollectionView, withIdentifier identifier: String) {
        collectionView.register(.init(nibName: "TestimonialCell", bundle: .module),
                                forCellWithReuseIdentifier: identifier)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        applyCornerRadius(value: 9.0)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
    }

    func update(with viewModel: TestimonialViewModel, attributes: CollectionViewCellAttributes) {
        backgroundColor = viewModel.colorScheme.background.secondary
        for (index, view) in starImageViews.enumerated() {
            let isFilled = viewModel.testimonial.rating >= Float(index + 1)
            let imageName = isFilled ? "icTestimonialStarFilled" : "icTestimonialStarEmpty"
            view.tintColor = viewModel.colorScheme.genericAction.active
            view.image = .init(named: imageName, in: .module, with: nil)
        }

        messageLabel.textColor = viewModel.colorScheme.foreground.secondary
        messageLabel.text = "“\(viewModel.testimonial.message)”"
    }
}
