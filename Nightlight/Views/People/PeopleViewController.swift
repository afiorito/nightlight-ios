import UIKit

public class PeopleViewController: UIViewController {
    
    public var dataSource: TableViewArrayPaginatedDataSource<PersonTableViewCell>
    
    private let viewModel: PeopleViewModel
    
    public var peopleView: PeopleView {
        return view as! PeopleView
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
    
    init(viewModel: PeopleViewModel) {
        self.viewModel = viewModel
        self.dataSource = TableViewArrayPaginatedDataSource(reuseIdentifier: PersonTableViewCell.className)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        removeDidChangeThemeObserver()
    }
    
    public override func loadView() {
        view = PeopleView()
    }
    
    private func loadMorePeople(fromStart: Bool = false) {
        if fromStart { viewModel.resetPaging() }

        viewModel.getPeople { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let people):
                self.dataSource.emptyViewDescription = EmptyViewDescription.noUsersMessages
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
                self.showToast("Could not connect to Nightlight.", severity: .urgent)
            }
        }
    }
    
}

// MARK: - Searchable

extension PeopleViewController: Searchable {
    @objc public func updateQuery(text: String) {
        guard text != viewModel.filter else {
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
