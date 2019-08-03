import UIKit

public class SettingsViewController: UIViewController {

    private enum Section: Int, CaseIterable {
        case appreciation = 0
        case general
        case feedback
        case about
        case account
    }
    
    private let viewModel: SettingsViewModel
    
    public weak var delegate: SettingsViewControllerDelegate?
    
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
    
    init(viewModel: SettingsViewModel) {
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
        
        updateColors(for: theme)
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        (navigationController as? Themeable)?.updateColors(for: theme)
        navigationController?.navigationBar.barTintColor = .alternateBackground(for: theme)
        navigationController?.navigationBar.backgroundColor = .alternateBackground(for: theme)
        navigationController?.navigationBar.setBackgroundImage(UIColor.alternateBackground(for: theme).asImage(), for: .default)

        super.viewWillAppear(animated)
        
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            tableView.reloadRows(at: [selectedIndexPath], with: .automatic)
        }
     }
    
    deinit {
        removeDidChangeThemeObserver()
    }
    
    public override func loadView() {
        view = tableView
    }
    
    private func formatTokens(for font: UIFont?) -> NSAttributedString {
        let string = NSMutableAttributedString(string: "")
        
        let imageAttachment = TokenImageAttachment(font: font)
        imageAttachment.image = UIImage(named: "glyph_token")
        
        string.appendTokenAttachment(imageAttachment)
        string.append(NSAttributedString(string: "\(viewModel.tokens)"))
        
        return string
    }

}

// MARK: - UITableView DataSource

extension SettingsViewController: UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        return Section.allCases.count
    }
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch Section(rawValue: section) {
        case .appreciation: return 1
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
        case .appreciation:
            settingsCell = appreciationCell(for: indexPath)
        case .general:
            settingsCell = generalCell(for: indexPath)
        case .feedback:
            settingsCell = feedbackCell(for: indexPath)
        case .about:
            settingsCell = aboutCell(for: indexPath)
        case .account:
            let cell = tableView.dequeueReusableCell(withIdentifier: BasicOptionTableViewCell.className,
                                                     for: indexPath) as! BasicOptionTableViewCell
                            
            cell.title = "Sign out"
            
            settingsCell = cell
            
        default: return UITableViewCell()
        }
        
        (settingsCell as? Themeable)?.updateColors(for: theme)
        
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
    private func appreciationCell(for indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: InformationRightDetailTableViewCell.className,
                                                 for: indexPath) as! InformationRightDetailTableViewCell
        
        cell.title = "Nightlight Tokens"
        cell.detailTextLabel?.attributedText = formatTokens(for: cell.detailTextLabel?.font)
        
        return cell
    }

    private func generalCell(for indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: SelectOptionTableViewCell<Theme>.className,
                                                     for: indexPath) as! SelectOptionTableViewCell<Theme>
            
            cell.optionName = "Theme"
            cell.optionValue = viewModel.theme
            
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: SelectOptionTableViewCell<MessageDefault>.className,
                                                     for: indexPath) as! SelectOptionTableViewCell<MessageDefault>
                            
            cell.optionName = "Send Message (Default)"
            cell.optionValue = viewModel.messageDefault
            
            return cell
        default: return UITableViewCell()
        }
    }
    
    private func feedbackCell(for indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: InformationTableViewCell.className,
                                                     for: indexPath) as! InformationTableViewCell
            
            cell.title = "Send Feedback"
            
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: InformationSubDetailTableViewCell.className,
                                                                     for: indexPath) as! InformationSubDetailTableViewCell
            
            cell.title = "Please Rate Nightlight"
            cell.subtitle = "0 people have rated this version."
            
            return cell
        default: return UITableViewCell()
        }
    }
    
    private func aboutCell(for indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: InformationTableViewCell.className,
                                                     for: indexPath) as! InformationTableViewCell
            
            cell.title = "About"
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: InformationTableViewCell.className,
                                                     for: indexPath) as! InformationTableViewCell
            
            cell.title = "Privacy Policy"
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: InformationTableViewCell.className,
                                                                 for: indexPath) as! InformationTableViewCell
                        
            cell.title = "Terms of Use"
            return cell
        default: return UITableViewCell()
        }
    }
}

// MARK: UITableView Delegate

extension SettingsViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch Section(rawValue: indexPath.section) {
        case .appreciation:
            appreciationTapAction(for: indexPath)
        case .general:
            generalTapAction(for: indexPath)
        case .feedback:
            feedbackTapAction(for: indexPath)
        case .about:
            aboutTapAction(for: indexPath)
        case .account:
            delegate?.settingsViewControllerDidSelectSignout(self)
        default: break
        }
    }
}

extension SettingsViewController {
    private func appreciationTapAction(for indexPath: IndexPath) {
        delegate?.settingsViewControllerDidSelectAppreciation(self)
    }

    private func generalTapAction(for indexPath: IndexPath) {
        switch indexPath.row {
        case 0: delegate?.settingsViewControllerDidSelectTheme(self, for: viewModel.theme)
        case 1: delegate?.settingsViewControllerDidSelectDefaultMessage(self, for: viewModel.messageDefault)
        default: break
        }
    }
    
    private func feedbackTapAction(for indexPath: IndexPath) {
        switch indexPath.row {
        case 0: delegate?.settingsViewControllerDidSelectFeedback(self)
        case 1: delegate?.settingsViewControllerDidSelectRate(self)
        default: break
        }
    }
    
    private func aboutTapAction(for indexPath: IndexPath) {
        switch indexPath.row {
        case 0: delegate?.settingsViewControllerDidSelectAbout(self)
        case 1: delegate?.settingsViewControllerDidSelectPrivacyPolicy(self)
        case 2: delegate?.settingsViewControllerDidSelectTermsOfUse(self)
        default: break
        }
    }
}

extension SettingsViewController {
    func didFailLoadingProducts() {
        showToast("Could not load products.", severity: .urgent)
    }
    
    public func didCompletePurchase() {
        tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
    }
    
    public func didFailPurchase() {
        showToast("Something Went Wrong.", severity: .urgent)
    }
}

// MARK: - Themeable

extension SettingsViewController: Themeable {
    func updateColors(for theme: Theme) {
        tableView.backgroundColor = .background(for: theme)
        tableView.separatorColor = .border(for: theme)
        navigationController?.navigationBar.barTintColor = .alternateBackground(for: theme)
        tableView.reloadData()
    }
}