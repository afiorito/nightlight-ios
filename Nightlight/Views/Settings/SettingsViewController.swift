import UIKit

public class SettingsViewController: UIViewController {

    private enum Section: Int, CaseIterable {
        case general = 0
        case feedback = 1
        case about = 2
        case account = 3
    }
    
    private let viewModel: SettingsViewModel
    
    public weak var delegate: SettingsViewControllerDelegate?
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(SelectOptionTableViewCell<Theme>.self, forCellReuseIdentifier: SelectOptionTableViewCell<Theme>.className)
        tableView.register(SelectOptionTableViewCell<MessageDefault>.self,
                           forCellReuseIdentifier: SelectOptionTableViewCell<MessageDefault>.className)
        tableView.register(InformationTableViewCell.self, forCellReuseIdentifier: InformationTableViewCell.className)
        tableView.register(BasicOptionTableViewCell.self, forCellReuseIdentifier: BasicOptionTableViewCell.className)
        
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
        navigationController?.navigationBar.barTintColor = .alternateBackground(for: theme)
        navigationController?.navigationBar.backgroundColor = .alternateBackground(for: theme)

        super.viewWillAppear(animated)
        
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selectedIndexPath, animated: true)
        }
     }
    
    deinit {
        removeDidChangeThemeObserver()
    }
    
    public override func loadView() {
        view = tableView
    }

}

// MARK: - UITableView DataSource

extension SettingsViewController: UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        return Section.allCases.count
    }
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch Section(rawValue: section) {
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
        guard let selectedIndexPath = tableView.indexPathForSelectedRow else {
            return
        }

        viewModel.updateTheme(theme)
        tableView.reloadRows(at: [selectedIndexPath], with: .automatic)
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
            let cell = tableView.dequeueReusableCell(withIdentifier: InformationTableViewCell.className,
                                                                     for: indexPath) as! InformationTableViewCell
            
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

// MARK: - Themeable

extension SettingsViewController: Themeable {
    func updateColors(for theme: Theme) {
        tableView.backgroundColor = .background(for: theme)
        tableView.separatorColor = .border(for: theme)
        navigationController?.navigationBar.barTintColor = .alternateBackground(for: theme)
        tableView.reloadData()
    }
}
