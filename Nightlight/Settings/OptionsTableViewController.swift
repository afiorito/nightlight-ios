import UIKit

/// A view controller for managing a list of setting options.
public class OptionsTableViewController<E: RawRepresentable & CaseIterable>: UITableViewController where E.RawValue == String {
    /// The delegate for managing UI actions.
    public weak var delegate: OptionsTableViewControllerDelegate?
    
    /// The actively selected option.
    public var currentOption: E
    
    override public func viewDidLoad() {
        super.viewDidLoad()

        addDidChangeThemeObserver()
        tableView.register(BasicOptionTableViewCell.self, forCellReuseIdentifier: BasicOptionTableViewCell.className)
    }
    
    init(currentOption: E) {
        self.currentOption = currentOption
        super.init(style: .grouped)
        
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
        return E.allCases.count
    }

    override public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BasicOptionTableViewCell.className, for: indexPath) as! BasicOptionTableViewCell

        let option = E.allCases[E.allCases.index(E.allCases.startIndex, offsetBy: indexPath.row)]
        
        cell.title = option.rawValue.capitalizingFirstLetter()
        cell.isSelected = option == currentOption
        cell.updateColors(for: theme)

        return cell
    }
    
    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let option = E.allCases[E.allCases.index(E.allCases.startIndex, offsetBy: indexPath.row)]

        currentOption = option
        tableView.reloadData()
        
        delegate?.optionsTableViewController(self, didSelect: option)
    }
    
    deinit {
        removeDidChangeThemeObserver()
    }

}

// MARK: - Themeable

extension OptionsTableViewController: Themeable {
    func updateColors(for theme: Theme) {
        setNeedsStatusBarAppearanceUpdate()
        tableView.backgroundColor = .background(for: theme)
        tableView.separatorColor = .border(for: theme)
        tableView.reloadData()
    }
}
