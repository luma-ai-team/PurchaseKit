//
//  Copyright © 2024 . All rights reserved.
//

import UIKit
import LumaKit
import GenericModule
import PurchaseKitCore

protocol SettingsViewOutput: ViewOutput {
    func premiumEventTriggered()
    func dismissEventTriggered()
}

final class SettingsViewController: ViewController<SettingsViewModel, Any, SettingsViewOutput> {
    override class var nib: ViewNib {
        return .init(name: nil, bundle: .module)
    }

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var versionLabel: UILabel!
    @IBOutlet weak var dismissButton: UIButton!
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad {
            dismissButton.tintColor = PurchaseKit.shared.configuration.colorScheme.foreground.primary
            versionLabel.textColor = PurchaseKit.shared.configuration.colorScheme.foreground.secondary

            tableView.contentInsetAdjustmentBehavior = .never
            tableView.backgroundColor = PurchaseKit.shared.configuration.colorScheme.background.primary
            tableView.separatorColor = PurchaseKit.shared.configuration.colorScheme.foreground.secondary.withAlphaComponent(0.25)
            tableView.register(SettingsActionCell.nib, forCellReuseIdentifier: SettingsActionCell.reuseIdentifier)
            tableView.register(SettingsTitleHeaderView.self,
                               forHeaderFooterViewReuseIdentifier: SettingsTitleHeaderView.reuseIdentifier)
            tableView.register(SettingsPremiumHeaderView.nib,
                               forHeaderFooterViewReuseIdentifier: SettingsPremiumHeaderView.reuseIdentifier)
            tableView.dataSource = self
            tableView.delegate = self
        }
    }

    override func update(with viewUpdate: Update<ViewModel>, animated: Bool) {
        viewUpdate(\.sections) { _ in
            tableView.reloadData()
        }

        viewUpdate(\.version) { (version: String) in
            versionLabel.text = "Version \(version)"
            view.setNeedsLayout()
        }
    }

    // MARK: - Actions

    @IBAction func dismissButtonPressed(_ sender: UIButton) {
        output.dismissEventTriggered()
    }
}

// MARK: - UITableViewDataSource

extension SettingsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.sections[section].actions.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = SettingsActionCell.reuseIdentifier
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? SettingsActionCell else {
            return .init()
        }

        cell.update(with: viewModel.sections[indexPath.section].actions[indexPath.row],
                    colorScheme: PurchaseKit.shared.configuration.colorScheme)
        return cell
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection index: Int) -> UIView? {
        let section = viewModel.sections[index]
        let colorScheme = PurchaseKit.shared.configuration.colorScheme

        switch section.header {
        case .none:
            return nil
        case .title(let title):
            let identifier = SettingsTitleHeaderView.reuseIdentifier
            let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: identifier) as? SettingsTitleHeaderView
            view?.update(title: title, colorScheme: colorScheme)
            return view
        case .premium(let viewModel, let isSubscribed):
            let identifier = SettingsPremiumHeaderView.reuseIdentifier
            let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: identifier) as? SettingsPremiumHeaderView
            view?.update(viewModel: viewModel, isSubscribed: isSubscribed, colorScheme: colorScheme)
            view?.delegate = self
            return view
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return viewModel.sections[section].header.height
    }
}

// MARK: - UITableViewDelegate

extension SettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.frame.origin.x = 16.0
        cell.frame.size.width = tableView.bounds.width - 32.0
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.sections[indexPath.section].actions[indexPath.row].handler()
    }
}

// MARK: - SettingsPremiumHeaderViewDelegate

extension SettingsViewController: SettingsPremiumHeaderViewDelegate {
    func settingsPremiumHeaderDidRequestAction(_ sender: SettingsPremiumHeaderView) {
        output.premiumEventTriggered()
    }
}
