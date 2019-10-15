import UIKit

public class MainSettingsViewController: SettingsViewController {
    /// A constant for denoting the section of the settings.
    private enum Section: Int {
        case tokens = 0
        case general
        case feedback
        case about
        case account
    }
    
    /// The viewModel for handling state.
    private let viewModel: SettingsViewModel
    
    public init(viewModel: SettingsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)

        sections = [
            // MARK: - Tokens Section.
            
            SettingsSection(settings: [
                Setting(
                    cellType: InformationRightDetailTableViewCell.self,
                    configureCell: { [weak self] cell in
                        guard let self = self, let cell = cell as? InformationRightDetailTableViewCell
                            else { return }
                        
                        cell.title = Strings.nightlightTokens
                        cell.isLoading = viewModel.isTokensLoading
                        cell.detailTextLabel?.attributedText = self.formatTokens(for: cell.detailTextLabel?.font)
                        cell.updateColors(for: self.theme)
                    },
                    selectionAction: { _ in
                        viewModel.buyTokens()
                    }
                )
            ]),
            
            // MARK: - Options Section
            
            SettingsSection(settings: [
                Setting(
                    cellType: SelectOptionTableViewCell<Theme>.self,
                    configureCell: { [weak self] cell in
                        guard let self = self, let cell = cell as? SelectOptionTableViewCell<Theme>
                            else { return }
                        
                        cell.optionName = Strings.setting.theme
                        cell.optionValue = self.viewModel.theme
                        cell.updateColors(for: self.theme)
                    },
                    selectionAction: { _ in
                        viewModel.changeTheme()
                    }
                ),
                Setting(
                    cellType: SelectOptionTableViewCell<MessageDefault>.self,
                    configureCell: { [weak self] cell in
                        guard let self = self, let cell = cell as? SelectOptionTableViewCell<MessageDefault>
                            else { return }
                        
                        cell.optionName = Strings.setting.sendMessage
                        cell.optionValue = self.viewModel.messageDefault
                        cell.updateColors(for: self.theme)
                    },
                    selectionAction: { _ in
                        viewModel.changeMessageDefault()
                    }
                )
            ]),
            
            // MARK: - Feedback Section.
            
            SettingsSection(settings: [
                Setting(
                    cellType: InformationTableViewCell.self,
                    configureCell: { [weak self] cell in
                        guard let self = self, let cell = cell as? InformationTableViewCell
                            else { return }
                        
                        cell.title = Strings.setting.sendFeedback
                        cell.updateColors(for: self.theme)
                    },
                    selectionAction: { _ in
                        viewModel.selectFeedback()
                    }
                ),
                Setting(
                    cellType: InformationSubDetailTableViewCell.self,
                    configureCell: { [weak self] cell in
                        guard let self = self, let cell = cell as? InformationSubDetailTableViewCell
                            else { return }
                        
                        cell.title = Strings.setting.rateNightlight
                        cell.subtitle = Strings.setting.ratingCount(self.viewModel.userRatingCountForCurrentVersion)
                        cell.updateColors(for: self.theme)
                    },
                    selectionAction: { _ in
                        viewModel.selectRating()
                    }
                )
            ]),
            
            // MARK: - About Section.
            
            SettingsSection(settings: [
                Setting(
                    cellType: InformationTableViewCell.self,
                    configureCell: { [weak self] cell in
                        guard let self = self, let cell = cell as? InformationTableViewCell
                            else { return }
                        
                        cell.title = Strings.setting.about
                        cell.updateColors(for: self.theme)
                    }, selectionAction: { _ in
                        viewModel.selectAbout()
                    }
                ),
                Setting(
                    cellType: InformationTableViewCell.self,
                    configureCell: { [weak self] cell in
                        guard let self = self, let cell = cell as? InformationTableViewCell
                            else { return }
                        
                        cell.title = Strings.setting.privacyPolicy
                        cell.updateColors(for: self.theme)
                    }, selectionAction: { _ in
                        viewModel.selectPrivacyPolicy()
                    }
                ),
                Setting(
                    cellType: InformationTableViewCell.self,
                    configureCell: { [weak self] cell in
                        guard let self = self, let cell = cell as? InformationTableViewCell
                            else { return }
                        
                        cell.title = Strings.setting.termsOfUse
                        cell.updateColors(for: self.theme)
                    }, selectionAction: { _ in
                        viewModel.selectTermsOfUse()
                    }
                )
            ]),
            SettingsSection(settings: [
                Setting(
                    cellType: BasicOptionTableViewCell.self,
                    configureCell: { [weak self] cell in
                        guard let self = self, let cell = cell as? BasicOptionTableViewCell
                            else { return }
                        
                        cell.title = Strings.signOut
                        cell.updateColors(for: self.theme)
                    },
                    selectionAction: { _ in
                        viewModel.signOut()
                    }
                )
            ])
        ]
        
        registerCellClasses()
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.loadRatings()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        navigationController?.setStyle(.secondary, for: theme)
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
    
    /**
     Format the user tokens string.
     
     - parameter font: the font used to size the token glyph.
     */
    private func formatTokens(for font: UIFont?) -> NSAttributedString {
        let string = NSMutableAttributedString(string: "")
        
        let imageAttachment = TokenImageAttachment(font: font)
        imageAttachment.image = UIImage.glyph.token
        
        string.appendTokenAttachment(imageAttachment)
        string.append(NSAttributedString(string: "\(viewModel.tokens)"))
        
        return string
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - SettingsViewModel UI Delegate

extension MainSettingsViewController: SettingsViewModelUIDelegate {
    public func updateView() {
        tableView.reloadData()
    }
    
    public func updateTokens() {
        tableView.reloadRows(at: [IndexPath(row: 0, section: Section.tokens.rawValue)], with: .none)
    }
    
    public func didFetchRatings() {
        tableView.reloadRows(at: [IndexPath(row: 1, section: Section.feedback.rawValue)], with: .none)
    }
    
    public func didCompletePurchase() {
        tableView.reloadRows(at: [IndexPath(row: 0, section: Section.tokens.rawValue)], with: .none)
    }
    
    public func didFailPurchase() {
        showToast(Strings.error.somethingWrong, severity: .urgent)
    }
    
    public func didFailToFetchRatings(with error: Error) {}
    
}
