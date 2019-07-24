import UIKit

public class OptionsTableViewController<E: RawRepresentable & CaseIterable>: UITableViewController where E.RawValue == String {

    public weak var delegate: OptionsTableViewControllerDelegate?
    
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
    
    deinit {
        removeDidChangeThemeObserver()
    }
    
    // MARK: - Table view data source

    override public func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
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

}

extension OptionsTableViewController: Themeable {
    func updateColors(for theme: Theme) {
        setNeedsStatusBarAppearanceUpdate()
        tableView.backgroundColor = .background(for: theme)
        tableView.separatorColor = .border(for: theme)
        tableView.reloadData()
    }
}
