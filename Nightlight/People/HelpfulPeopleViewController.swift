import UIKit

/// A view controller for managing a list of helpful people.
public class HelpfulPeopleViewController: UIViewController {
    /// The viewModel for handling state.
    private let viewModel: HelpfulPeopleViewModel

    /// The view that the `HelpfulPeopleViewController` manages.
    public var peopleView: PeopleView {
        return view as! PeopleView
    }
    
    /// The object that acts as the data source of the table view.
    private lazy var dataSource: SimpleTableViewDataSource<PersonTableViewCell> = {
        SimpleTableViewDataSource(reuseIdentifier: PersonTableViewCell.className, cellConfigurator: configureCell)
    }()
    
    /// A refresh control for people.
    private let refreshControl = UIRefreshControl()
    
    public init(viewModel: HelpfulPeopleViewModel) {
        self.viewModel = viewModel
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
        peopleView.tableView.addSubview(refreshControl) // assigning tableView.refreshControl causes jitterying
        peopleView.tableView.register(HelpfulPeopleHeader.self, forHeaderFooterViewReuseIdentifier: HelpfulPeopleHeader.className)
        
        updateColors(for: theme)

        viewModel.fetchHelpfulPeople()
    }
    
    public override func loadView() {
        view = PeopleView()
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    public func configureCell(_ cell: PersonTableViewCell, at indexPath: IndexPath) {
        cell.configure(with: viewModel.personViewModel(at: indexPath))
    }
    
    deinit {
        removeDidChangeThemeObserver()
    }
    
}

// MARK: - HelpfulPeopleViewModel UI Delegate

extension HelpfulPeopleViewController: HelpfulPeopleViewModelUIDelegate {
    public func didBeginFetchingHelpfulPeople() {
        if !refreshControl.isRefreshing {
            peopleView.tableView.isLoading = true
        }
    }
    
    public func didEndFetchingHelpfulPeople() {
        peopleView.tableView.isLoading = false
        if refreshControl.isRefreshing {
            refreshControl.endRefreshing()
        }
    }
    
    public func didFailToFetchHelpfulPeople(with error: PersonError) {
        if dataSource.isEmpty {
            dataSource.emptyViewDescription = EmptyViewDescription.noLoad
            peopleView.tableView.reloadData()
        }
        showToast(Strings.error.couldNotConnect, severity: .urgent)
    }
    
    public func didFetchHelpfulPeople(with count: Int) {
        dataSource.emptyViewDescription = .none

        dataSource.rowCount = count
        peopleView.tableView.reloadSections(IndexSet(integer: 0), with: .fade)
    }

}

// MARK: - UITableView Delegate

extension HelpfulPeopleViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard !dataSource.isEmpty else { return nil }
        
        return tableView.dequeueReusableHeaderFooterView(withIdentifier: HelpfulPeopleHeader.className)
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return dataSource.isEmpty ? 0 : UITableView.automaticDimension
    }
    
    public func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 100
    }
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if refreshControl.isRefreshing {
            viewModel.fetchHelpfulPeople()
        }
    }
}

// MARK: - Themeable

extension HelpfulPeopleViewController: Themeable {
    func updateColors(for theme: Theme) {
        peopleView.updateColors(for: theme)
        refreshControl.tintColor = .gray(for: theme)
        (tableView(peopleView.tableView, viewForHeaderInSection: 0) as? Themeable)?.updateColors(for: theme)
    }
}
