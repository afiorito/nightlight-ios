import UIKit

public class HelpfulPeopleViewController: UIViewController {
    
    private let dataSource: TableViewArrayDataSource<PersonTableViewCell>
    
    public var peopleView: PeopleView {
        return view as! PeopleView
    }
    
    init(viewModel: PeopleViewModel) {
        self.dataSource = TableViewArrayPaginatedDataSource(reuseIdentifier: PersonTableViewCell.className)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        addDidChangeThemeObserver()
        
        peopleView.tableView.delegate = self
        peopleView.tableView.dataSource = dataSource
        
        dataSource.data = (0..<100).map { _ in PersonViewModel() }
        
        prepareSubviews()
        
        updateColors(for: theme)
    }
    
    deinit {
        removeDidChangeThemeObserver()
    }
    
    public override func loadView() {
        view = PeopleView()
    }
    
    private func prepareSubviews() {
        
    }
    
}

// MARK: - UITableView Delegate

extension HelpfulPeopleViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return HelpfulPeopleHeader()
    }
}

// MARK: - Themeable

extension HelpfulPeopleViewController: Themeable {
    func updateColors(for theme: Theme) {
        peopleView.updateColors(for: theme)
        (peopleView.tableView.tableHeaderView as? Themeable)?.updateColors(for: theme)
    }
}
