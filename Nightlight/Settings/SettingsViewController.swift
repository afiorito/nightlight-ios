import UIKit

public class SettingsViewController: UIViewController, Themeable {
    
    public var sections = [SettingsSection]()
    
    let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.tableFooterView = UIView()
        return tableView
    }()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        addDidChangeThemeObserver()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        prepareSubviews()
        updateColors(for: theme)
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
    
    func registerCellClasses() {
        sections.forEach { $0.settings.forEach { tableView.register($0.cellType) } }
    }
    
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
    
    deinit {
        removeDidChangeThemeObserver()
    }
    
}

// MARK: - UITableView DataSource

extension SettingsViewController: UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].settings.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let setting = sections[indexPath.section].settings[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: setting.cellType.className, for: indexPath)
        setting.configureCell?(cell)
        
        return cell
    }
    
}

// MARK: UITableView Delegate

extension SettingsViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        sections[indexPath.section].settings[indexPath.row].selectionAction?(indexPath)
    }
}
