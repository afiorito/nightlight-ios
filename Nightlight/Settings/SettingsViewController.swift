import UIKit

/// A view controller for managing a list of settings.
public class SettingsViewController: UIViewController {
    /// A constant for denoting the section of the settings.
    private enum Section: Int, CaseIterable {
        case tokens = 0
        case general
        case feedback
        case about
        case account
    }
    
    /// The viewModel for handling state.
    private let viewModel: SettingsViewModel
    
    /// A table view for displaying a list of settings.
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(SelectOptionTableViewCell<Theme>.self)
        tableView.register(SelectOptionTableViewCell<MessageDefault>.self)
        tableView.register(InformationTableViewCell.self)
        tableView.register(InformationSubDetailTableViewCell.self)
        tableView.register(InformationRightDetailTableViewCell.self)
        tableView.register(BasicOptionTableViewCell.self)

        tableView.tableFooterView = UIView()
        return tableView
    }()
    
    public init(viewModel: SettingsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        addDidChangeThemeObserver()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        prepareSubviews()
        updateColors(for: theme)
        
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
    
    private func prepareSubviews() {
        view.addSubviews(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
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
    
    deinit {
        removeDidChangeThemeObserver()
    }

}

// MARK: - SettingsViewModel UI Delegate

extension SettingsViewController: SettingsViewModelUIDelegate {
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

// MARK: - UITableView DataSource

extension SettingsViewController: UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        return Section.allCases.count
    }
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch Section(rawValue: section) {
        case .tokens: return 1
        case .general: return 2
        case .feedback: return 2
        case .about: return 3
        case .account: return 1
        default: return 0
        }
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let settingsCell: UITableViewCell

        switch Section(rawValue: indexPath.section) {
        case .tokens:
            settingsCell = tokensCell(for: indexPath)
        case .general:
            settingsCell = generalCell(for: indexPath)
        case .feedback:
            settingsCell = feedbackCell(for: indexPath)
        case .about:
            settingsCell = aboutCell(for: indexPath)
        case .account:
            let cell = tableView.dequeueReusableCell(withIdentifier: BasicOptionTableViewCell.className,
                                                     for: indexPath) as! BasicOptionTableViewCell
                            
            cell.title = Strings.signOut
            cell.updateColors(for: theme)
            
            settingsCell = cell
            
        default: return UITableViewCell()
        }
        
        return settingsCell
    }
    
    public func didChangeTheme(to theme: Theme) {
        viewModel.updateTheme(theme)
    }
    
    public func didChangeMessageDefault(to default: MessageDefault) {
        guard let selectedIndexPath = tableView.indexPathForSelectedRow else {
            return
        }

        viewModel.updateMessageDefault(`default`)
        tableView.reloadRows(at: [selectedIndexPath], with: .automatic)
    }

}

// MARK: - Cell Preparation

extension SettingsViewController {
    private func tokensCell(for indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: InformationRightDetailTableViewCell.className,
                                                 for: indexPath) as! InformationRightDetailTableViewCell
        
        cell.title = Strings.nightlightTokens
        cell.isLoading = viewModel.isTokensLoading
        cell.detailTextLabel?.attributedText = formatTokens(for: cell.detailTextLabel?.font)
        cell.updateColors(for: theme)
        
        return cell
    }

    private func generalCell(for indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: SelectOptionTableViewCell<Theme>.className,
                                                     for: indexPath) as! SelectOptionTableViewCell<Theme>
            
            cell.optionName = Strings.setting.theme
            cell.optionValue = viewModel.theme
            cell.updateColors(for: theme)
            
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: SelectOptionTableViewCell<MessageDefault>.className,
                                                     for: indexPath) as! SelectOptionTableViewCell<MessageDefault>
                            
            cell.optionName = Strings.setting.sendMessage
            cell.optionValue = viewModel.messageDefault
            cell.updateColors(for: theme)
            
            return cell
        default: return UITableViewCell()
        }
    }
    
    private func feedbackCell(for indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: InformationTableViewCell.className,
                                                     for: indexPath) as! InformationTableViewCell
            
            cell.title = Strings.setting.sendFeedback
            cell.updateColors(for: theme)
            
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: InformationSubDetailTableViewCell.className,
                                                                     for: indexPath) as! InformationSubDetailTableViewCell
            
            cell.title = Strings.setting.rateNightlight
            cell.subtitle = Strings.setting.ratingCount(viewModel.userRatingCountForCurrentVersion)
            cell.updateColors(for: theme)

            return cell
        default: return UITableViewCell()
        }
    }
    
    private func aboutCell(for indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: InformationTableViewCell.className,
                                                     for: indexPath) as! InformationTableViewCell
            
            cell.title = Strings.setting.about
            cell.updateColors(for: theme)
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: InformationTableViewCell.className,
                                                     for: indexPath) as! InformationTableViewCell
            
            cell.title = Strings.setting.privacyPolicy
            cell.updateColors(for: theme)
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: InformationTableViewCell.className,
                                                                 for: indexPath) as! InformationTableViewCell
                        
            cell.title = Strings.setting.termsOfUse
            cell.updateColors(for: theme)
            return cell
        default: return UITableViewCell()
        }
    }
}

// MARK: UITableView Delegate

extension SettingsViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        switch Section(rawValue: indexPath.section) {
        case .tokens:
            tokensTapAction(for: indexPath)
        case .general:
            generalTapAction(for: indexPath)
        case .feedback:
            tableView.deselectRow(at: indexPath, animated: true)
            feedbackTapAction(for: indexPath)
        case .about:
            aboutTapAction(for: indexPath)
        case .account:
            viewModel.signOut()
        default: break
        }
    }
}

// MARK: - Cell Selection Actions

extension SettingsViewController {
    private func tokensTapAction(for indexPath: IndexPath) {
        viewModel.buyTokens()
    }

    private func generalTapAction(for indexPath: IndexPath) {
        switch indexPath.row {
        case 0: viewModel.changeTheme()
        case 1: viewModel.changeMessageDefault()
        default: break
        }
    }
    
    private func feedbackTapAction(for indexPath: IndexPath) {
        switch indexPath.row {
        case 0: viewModel.selectFeedback()
        case 1: viewModel.selectRating()
        default: break
        }
    }
    
    private func aboutTapAction(for indexPath: IndexPath) {
        switch indexPath.row {
        case 0: viewModel.selectAbout()
        case 1: viewModel.selectPrivacyPolicy()
        case 2: viewModel.selectTermsOfUse()
        default: break
        }
    }
}

// MARK: - Themeable

extension SettingsViewController: Themeable {
    func updateColors(for theme: Theme) {
        if theme == .system {
            tableView.separatorColor = nil
        } else {
            tableView.separatorColor = .separator(for: theme)
        }

        navigationController?.setStyle(.secondary, for: theme)
        tableView.backgroundColor = .background(for: theme)
        tableView.reloadData()
    }
}
