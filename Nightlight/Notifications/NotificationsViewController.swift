import UIKit

/// A view controller for managing a list of notifications.
public class NotificationsViewController: UIViewController {
    /// The viewModel for handling state.
    private let viewModel: UserNotificationsViewModel
    
    private var notificationsView: NotificationsView {
        return view as! NotificationsView
    }
    
    /// A refresh control for notifications.
    private let refreshControl = UIRefreshControl()
    
    /// A view displayed when the notifications list is empty.
    public var emptyViewDescription: EmptyViewDescription?
    
    // The object that acts as the data source of the table view.
    private let dataSource: TableViewArrayPaginatedDataSource<NotificationTableViewCell>
    
    init(viewModel: UserNotificationsViewModel) {
        self.viewModel = viewModel
        self.dataSource = TableViewArrayPaginatedDataSource(reuseIdentifier: NotificationTableViewCell.className)
        
        super.init(nibName: nil, bundle: nil)
        
        self.dataSource.cellDelegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        addDidChangeThemeObserver()
        updateColors(for: theme)
        
        notificationsView.tableView.dataSource = dataSource
        notificationsView.tableView.delegate = self
        notificationsView.tableView.prefetchDataSource = dataSource
        notificationsView.tableView.refreshControl = refreshControl
        
        dataSource.prefetchCallback = { [weak self] in
            self?.loadMoreNotifications()
        }

        notificationsView.tableView.contentOffset = CGPoint(x: 0, y: -refreshControl.frame.size.height)
        refreshControl.beginRefreshing()
        refresh()
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if UIApplication.shared.applicationIconBadgeNumber > 0 || tabBarController?.tabBar.subview(ofType: BadgeView.self) != nil {
            refresh()
            UIApplication.shared.applicationIconBadgeNumber = 0
        }
    }
    
    public override func loadView() {
        view = NotificationsView()
    }
    
    deinit {
        removeDidChangeThemeObserver()
    }
    
    /**
    Requests more notifications to be displayed.
    
    - parameter fromStart: A boolean that determines if notifications are loaded from the beginning of the list or appended to the current list.
    */
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
                
                (self.tabBarController as? NLTabBarController)?.removeBadge()
                
            case .failure:
                // ensure empty view is updated properly.
                if self.dataSource.data.isEmpty {
                    self.dataSource.emptyViewDescription = EmptyViewDescription.noLoad
                    self.notificationsView.tableView.reloadData()
                }
                self.showToast(Strings.error.couldNotConnect, severity: .urgent)
            }
        }
    }
    
    /**
     Refresh the table view.
     */
    @objc private func refresh() {
        loadMoreNotifications(fromStart: true)
    }
}

// MARK: - UITableView Delegate

extension NotificationsViewController: UITableViewDelegate {
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if refreshControl.isRefreshing {
            refresh()
        }
    }
}

// MARK: - Themeable

extension NotificationsViewController: Themeable {
    var theme: Theme {
        return viewModel.theme
    }

    public func updateColors(for theme: Theme) {
        navigationController?.setStyle(.primary, for: theme)
        notificationsView.updateColors(for: theme)
        refreshControl.tintColor = .gray(for: theme)
        (navigationItem.titleView as? Themeable)?.updateColors(for: theme)
    }
}
