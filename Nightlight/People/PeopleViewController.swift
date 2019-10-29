import UIKit

/// A view controller for managing a list of people.
public class PeopleViewController: UIViewController {
    /// The viewModel for handling state.
    private let viewModel: PeopleViewModel

    /// The view that the `PeopleViewController` manages.
    public var peopleView: PeopleView {
        return view as! PeopleView
    }
        
    /// A view displayed when the people list is empty.
    public var emptyViewDescription: EmptyViewDescription?

    /// The object that acts as the data source of the table view.
    public lazy var dataSource: SimpleTableViewPaginatedDataSource<PersonTableViewCell> = {
        SimpleTableViewPaginatedDataSource(reuseIdentifier: PersonTableViewCell.className, cellConfigurator: configureCell)
    }()
    
    public init(viewModel: PeopleViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
        
        addDidChangeThemeObserver()
        
        peopleView.tableView.prefetchDataSource = dataSource
        peopleView.tableView.dataSource = dataSource
        
        dataSource.prefetchCallback = { [weak self] in
            self?.viewModel.fetchPeople(fromStart: false)
        }
        
        updateColors(for: theme)
        viewModel.fetchPeople(fromStart: true)
    }
    
    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        if isBeingRemoved {
            viewModel.finish()
        }
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

// MARK: - PeopleViewModel UI Delegate

extension PeopleViewController: PeopleViewModelUIDelegate {
    public func didBeginFetchingPeople(fromStart: Bool) {
        if viewModel.totalCount <= 0 {
            peopleView.tableView.isLoading = true
        }
    }
    
    public func didEndFetchingPeople() {
        peopleView.tableView.isLoading = false
    }
    
    public func didFailToFetchPeople(with error: PersonError) {
        if dataSource.isEmpty {
            dataSource.emptyViewDescription = EmptyViewDescription.noLoad
            peopleView.tableView.reloadData()
        } else {
            showToast(Strings.error.couldNotConnect, severity: .urgent)
        }
    }
    
    public func didFetchPeople(with count: Int, fromStart: Bool) {
        dataSource.emptyViewDescription = emptyViewDescription
        dataSource.totalCount = viewModel.totalCount
        
        if fromStart {
            dataSource.rowCount = count
            peopleView.tableView.reloadSections(IndexSet(integer: 0), with: .fade)
        } else {
            let newIndexPaths = dataSource.incrementCount(count)
            peopleView.tableView.insertRows(at: newIndexPaths, with: .none)
        }
    }
    
    public func updateTitle(_ title: String) {
        self.title = title
    }
}

// MARK: - Searchable

extension PeopleViewController: Searchable {
    @objc public func updateQuery(text: String) {
        guard text != viewModel.filter else { return }
        
        viewModel.filter = text
        
        guard !text.isEmpty else {
            self.dataSource.rowCount = 0
            self.dataSource.totalCount = 0
            self.peopleView.tableView.reloadData()
            return
        }
        
        viewModel.fetchPeople(fromStart: true)
    }
}

// MARK: - Themeable

extension PeopleViewController: Themeable {
    func updateColors(for theme: Theme) {
        peopleView.updateColors(for: theme)
        (peopleView.tableView.tableHeaderView as? Themeable)?.updateColors(for: theme)
    }
}
