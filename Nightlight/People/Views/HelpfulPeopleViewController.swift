import UIKit

public class HelpfulPeopleViewController: UIViewController {
    
    private let viewModel: PeopleViewModel
    
    private let dataSource: TableViewArrayDataSource<PersonTableViewCell>
    
    private let refreshControl = UIRefreshControl()
    
    public var peopleView: PeopleView {
        return view as! PeopleView
    }
    
    init(viewModel: PeopleViewModel) {
        self.viewModel = viewModel
        self.dataSource = TableViewArrayDataSource(reuseIdentifier: PersonTableViewCell.className)
        
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
        peopleView.tableView.refreshControl = refreshControl
        peopleView.tableView.register(HelpfulPeopleHeader.self, forHeaderFooterViewReuseIdentifier: HelpfulPeopleHeader.className)
        
        updateColors(for: theme)

        loadPeople()
    }
    
    deinit {
        removeDidChangeThemeObserver()
    }
    
    public override func loadView() {
        view = PeopleView()
    }
    
    private func loadPeople() {
        viewModel.getHelpfulPeople { [weak self] result in
            guard let self = self else { return }
            
            if self.refreshControl.isRefreshing {
                self.refreshControl.endRefreshing()
            }
            
            switch result {
            case .success(let people):
                self.dataSource.emptyViewDescription = .none
                
                self.dataSource.data = people
                self.peopleView.tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
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
    
    @objc private func refresh() {
        loadPeople()
    }
    
}

// MARK: - UITableView Delegate

extension HelpfulPeopleViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard !dataSource.data.isEmpty else { return nil }
        
        return tableView.dequeueReusableHeaderFooterView(withIdentifier: HelpfulPeopleHeader.className)
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return dataSource.data.isEmpty ? 0 : UITableView.automaticDimension
    }
    
    public func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 100
    }
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if refreshControl.isRefreshing {
            refresh()
        }
    }
}

// MARK: - Themeable

extension HelpfulPeopleViewController: Themeable {
    func updateColors(for theme: Theme) {
        peopleView.updateColors(for: theme)
        refreshControl.tintColor = .neutral
        (tableView(peopleView.tableView, viewForHeaderInSection: 0) as? Themeable)?.updateColors(for: theme)
    }
}