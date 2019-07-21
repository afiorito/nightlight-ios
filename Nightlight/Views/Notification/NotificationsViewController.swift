import UIKit

public class NotificationsViewController: UIViewController {
    private let viewModel: UserNotificationsViewModel
    
    private var notificationsView: NotificationsView {
        return view as! NotificationsView
    }
    
    private let refreshControl = UIRefreshControl()
    
    public var emptyViewDescription: EmptyViewDescription?
    
    private let dataSource: TableViewArrayPaginatedDataSource<NotificationTableViewCell>
    
    init(viewModel: UserNotificationsViewModel) {
        self.viewModel = viewModel
        self.dataSource = TableViewArrayPaginatedDataSource(reuseIdentifier: NotificationTableViewCell.className)
        
        super.init(nibName: nil, bundle: nil)
        
        self.dataSource.cellDelegate = self
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        addDidChangeThemeObserver()
        
        updateColors(for: theme)
        
        notificationsView.tableView.dataSource = dataSource
        notificationsView.tableView.prefetchDataSource = dataSource
        notificationsView.tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        
        dataSource.prefetchCallback = { [weak self] in
            self?.loadMoreNotifications()
        }

        self.refreshControl.beginRefreshing()
        refresh()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        removeDidChangeThemeObserver()
    }
    
    private func loadMoreNotifications(fromStart: Bool = false) {
        if fromStart { viewModel.resetPaging() }
        
        viewModel.getNotifications { [weak self] result in
            guard let self = self else { return }
            
            if self.refreshControl.isRefreshing {
                self.refreshControl.endRefreshing()
            }
            
            switch result {
            case .success(let notifications):
                self.dataSource.emptyViewDescription = self.emptyViewDescription
                self.dataSource.totalCount = self.viewModel.totalCount
                
                if fromStart {
                    self.dataSource.data = notifications
                    self.notificationsView.tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
                } else {
                    let newIndexPaths = self.dataSource.updateData(with: notifications)
                    self.notificationsView.tableView.insertRows(at: newIndexPaths, with: .none)
                }
                
            case .failure:
                // ensure empty view is updated properly.
                if self.dataSource.data.isEmpty {
                    self.dataSource.emptyViewDescription = EmptyViewDescription.noLoad
                    self.notificationsView.tableView.reloadData()
                }
                self.showToast("Could not connect to Nightlight.", severity: .urgent)
            }
        }
    }
    
    public override func loadView() {
        view = NotificationsView()
    }
    
    @objc private func refresh() {
        loadMoreNotifications(fromStart: true)
    }
}

// MARK: - Themeable

extension NotificationsViewController: Themeable {
    var theme: Theme {
        return viewModel.theme
    }

    public func updateColors(for theme: Theme) {
        notificationsView.updateColors(for: theme)
        refreshControl.tintColor = .neutral
    }
}
