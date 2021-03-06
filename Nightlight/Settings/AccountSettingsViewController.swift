import UIKit

/// A view controller for a user's account settings.
public class AccountSettingsViewController: SettingsViewController {
    /// The viewModel for handling state.
    private let viewModel: AccountSettingsViewModel
    
    public init(viewModel: AccountSettingsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
        sections = [
            SettingsSection(settings: [
                Setting(
                    cellType: InformationRightDetailTableViewCell.self,
                    configureCell: { [weak self] cell in
                        guard let self = self, let cell = cell as? InformationRightDetailTableViewCell
                            else { return }
                        
                        cell.title = Strings.setting.email
                        cell.detailTextLabel?.text = viewModel.email
                        cell.updateColors(for: self.theme)
                    },
                    selectionAction: { [weak self] _ in
                        // without this, any code executed in this function is delayed.
                        self?.tableView.deselectRow(at: IndexPath(item: 0, section: 0), animated: false)
                        viewModel.selectEmail()
                    }
                ),
                Setting(
                    cellType: InformationTableViewCell.self,
                    configureCell: { [weak self] cell in
                        guard let self = self, let cell = cell as? InformationTableViewCell
                            else { return }
                        
                        cell.title = Strings.setting.changePassword
                        cell.updateColors(for: self.theme)
                        
                    },
                    selectionAction: { [weak self] _ in
                        // without this, any code executed in this function is delayed.
                        self?.tableView.deselectRow(at: IndexPath(item: 1, section: 0), animated: false)
                        viewModel.selectPassword()
                    }
                )
            ])
        ]
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.loadAccount()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selectedIndexPath, animated: true)
        }
    }
    
    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        if isBeingRemoved {
            viewModel.finish()
        }
    }
}

// MARK: - AccountSettingsViewModel UI Delegate

extension AccountSettingsViewController: AccountSettingsViewModelUIDelegate {
    public func didFetchAccount() {
        tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
    }
    
    public func didFailToFetchAccount(with error: Error) {
        showToast(Strings.error.couldNotLoadAccount, severity: .urgent)
    }
    
    public func didChangeEmail() {
        tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
        showToast(Strings.emailChangedSuccessfully, severity: .success)
    }
    
    public func didFailChangeEmail(with error: PersonError) {
        showToast(error.message, severity: .urgent)
    }
    
    public func didChangePassword() {
        tableView.reloadRows(at: [IndexPath(row: 1, section: 0)], with: .automatic)
        showToast(Strings.passwordChangedSuccessfully, severity: .success)
    }
    
    public func didFailChangePassword(with error: PersonError) {
        showToast(error.message, severity: .urgent)
    }
}
