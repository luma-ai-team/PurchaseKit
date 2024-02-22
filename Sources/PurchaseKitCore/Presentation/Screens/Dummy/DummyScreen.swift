//
//  DummyScreen.swift
//  
//
//  Created by Anton Kormakov on 18.10.2023.
//

import UIKit
import GenericModule

public final class DummyScreen: PurchaseKitViewController<DummyPage> {

    public override func viewDidLoad() {
        view.backgroundColor = .white
    }

    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        output?.moduleDidRequestNextPage(viewModel.page)
    }

    public override func update(with viewUpdate: Update<PurchaseKitScreenViewModel<DummyPage>>, animated: Bool) {
        super.update(with: viewUpdate, animated: animated)
        viewUpdate(\.page.value) { (value: Int) in
            view.backgroundColor = .init(red: CGFloat(value) / 255.0, green: 0.0, blue: 0.0, alpha: 1.0)
        }
    }
}
