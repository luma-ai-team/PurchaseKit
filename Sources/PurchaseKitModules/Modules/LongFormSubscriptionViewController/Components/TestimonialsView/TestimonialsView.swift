//
//  File.swift
//  
//
//  Created by Anton Kormakov on 06.03.2024.
//

import UIKit
import LumaKit

final class TestimonialsView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewLayout: UICollectionViewFlowLayout!
    
    private lazy var collectionViewManager: CollectionViewManager = .init(collectionView: collectionView)

    private let testimonials: [LongFormSubscriptionPage.Testimonial]
    private let colorScheme: ColorScheme

    init(testimonials: [LongFormSubscriptionPage.Testimonial], colorScheme: ColorScheme) {
        self.testimonials = testimonials
        self.colorScheme = colorScheme
        super.init(frame: .zero)

        Bundle.module.loadNibNamed("TestimonialsView", owner: self)
        addSubview(contentView)
        contentView.bindMarginsToSuperview()

        setup()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    private func setup() {
        titleLabel.textColor = colorScheme.foreground.primary

        let viewModels = testimonials.map { (testimonial: LongFormSubscriptionPage.Testimonial) in
            return TestimonialViewModel(testimonial: testimonial, colorScheme: colorScheme)
        }
        let section = BasicCollectionViewSection.uniform(cellType: TestimonialCell.self,
                                                         viewModels: viewModels,
                                                         selectionHandler: { _ in })
        section.insets = .init(horizontal: 32.0, vertical: 0.0)
        collectionViewLayout.minimumLineSpacing = 8.0
        collectionViewLayout.minimumInteritemSpacing = 8.0
        collectionViewManager.sections = [section]
    }
}
