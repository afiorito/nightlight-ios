import UIKit

/// A view controller for managing a list of setting options.
public class OptionsTableViewController<E: RawRepresentable & CaseIterable>: UITableViewController where E.RawValue == String {
    
    /// The viewModel for handling state.
    private let viewModel: OptionsViewModel<E>
    
    override public func viewDidLoad() {
        super.viewDidLoad()

        addDidChangeThemeObserver()
        tableView.register(BasicOptionTableViewCell.self, forCellReuseIdentifier: BasicOptionTableViewCell.className)
    }
    
    public init(viewModel: OptionsViewModel<E>) {
        self.viewModel = viewModel
        super.init(style: .grouped)
        
        title = viewModel.title
        
        updateColors(for: theme)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Table View DataSource

    override public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.optionCount
    }

    override public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BasicOptionTableViewCell.className, for: indexPath) as! BasicOptionTableViewCell

        let option = viewModel.option(at: indexPath)
        
        cell.title = option.rawValue.capitalizingFirstLetter()
        cell.isCurrentOption = option == viewModel.currentOption
        cell.updateColors(for: theme)

        return cell
    }
    
    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.selectOption(at: indexPath)
        tableView.reloadSections(IndexSet(integer: 0), with: .fade)
    }
    
    deinit {
        removeDidChangeThemeObserver()
    }

}

// MARK: - Themeable

extension OptionsTableViewController: Themeable {
    func updateColors(for theme: Theme) {
        for cell in (tableView.visibleCells as? [Themeable]) ?? [] {
            cell.updateColors(for: theme)
        }

        if theme == .system {
            tableView.separatorColor = nil
        } else {
            tableView.separatorColor = .separator(for: theme)
        }

        navigationController?.navigationBar.layoutIfNeeded()
        navigationController?.setStyle(.secondary, for: theme)
        setNeedsStatusBarAppearanceUpdate()
        tableView.backgroundColor = .background(for: theme)
    }
}
