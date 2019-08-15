import UIKit

/// A view controller for managing a list of people.
public class PeopleViewController: UIViewController {
    
    /// The object that acts as the data source of the table view.
    public var dataSource: TableViewArrayPaginatedDataSource<PersonTableViewCell>
    
    /// The viewModel for handling state.
    private let viewModel: PeopleViewModel
    
    public var peopleView: PeopleView {
        return view as! PeopleView
    }
    
    /// A view displayed when the people list is empty.
    public var emptyViewDescription: EmptyViewDescription?
    
    init(viewModel: PeopleViewModel) {
        self.viewModel = viewModel
        self.dataSource = TableViewArrayPaginatedDataSource(reuseIdentifier: PersonTableViewCell.className)
        
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
            self?.loadMorePeople()
        }
        
        updateColors(for: theme)
    }
    
    public override func loadView() {
        view = PeopleView()
    }
    
    /**
     Requests more people to be displayed.
     
     - parameter fromStart: A boolean that determines if people are loaded from the beginning of the list or appended to the current list.
     */
    private func loadMorePeople(fromStart: Bool = false) {
        if fromStart { viewModel.resetPaging() }

        viewModel.getPeople { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let people):
                self.dataSource.emptyViewDescription = self.emptyViewDescription
                self.dataSource.totalCount = self.viewModel.totalCount
                
                if fromStart {
                    self.dataSource.data = people
                    self.peopleView.tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
                } else {
                    let newIndexPaths = self.dataSource.updateData(with: people)
                    self.peopleView.tableView.insertRows(at: newIndexPaths, with: .none)
                }
            case .failure:
                // ensure empty view is updated properly.
                if self.dataSource.data.isEmpty {
                    self.dataSource.emptyViewDescription = EmptyViewDescription.noLoad
                    self.peopleView.tableView.reloadData()
                }
                self.showToast(Strings.error.couldNotConnect, severity: .urgent)
            }
        }
    }
    
    deinit {
        removeDidChangeThemeObserver()
    }
    
}

// MARK: - Searchable

extension PeopleViewController: Searchable {
    @objc public func updateQuery(text: String) {
        guard text != viewModel.filter else {
            self.dataSource.data.removeAll()
            self.peopleView.tableView.reloadData()
            return
        }
        
        viewModel.filter = text
        loadMorePeople(fromStart: true)
    }
    
}

// MARK: - Themeable

extension PeopleViewController: Themeable {
    func updateColors(for theme: Theme) {
        peopleView.updateColors(for: theme)
        (peopleView.tableView.tableHeaderView as? Themeable)?.updateColors(for: theme)
    }
}
