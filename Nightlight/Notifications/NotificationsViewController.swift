import UIKit

/// A view controller for managing a list of notifications.
public class NotificationsViewController: UIViewController {
    /// The viewModel for handling state.
    private let viewModel: UserNotificationsViewModel
    
    /// The view that the `NotificationsViewController` manages.
    private var notificationsView: NotificationsView {
        return view as! NotificationsView
    }
    
    /// A refresh control for notifications.
    private let refreshControl = UIRefreshControl()
    
    /// A view displayed when the notifications list is empty.
    public var emptyViewDescription: EmptyViewDescription?

    /// The object that acts as the data source of the table view.
    private lazy var dataSource: SimpleTableViewPaginatedDataSource<NotificationTableViewCell> = {
        SimpleTableViewPaginatedDataSource(reuseIdentifier: NotificationTableViewCell.className, cellConfigurator: configureCell)
    }()
    
    public init(viewModel: UserNotificationsViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        addDidChangeThemeObserver()
        addTitleView()
        
        updateColors(for: theme)
        
        notificationsView.tableView.dataSource = dataSource
        notificationsView.tableView.delegate = self
        notificationsView.tableView.prefetchDataSource = dataSource
        notificationsView.tableView.refreshControl = refreshControl
        
        dataSource.prefetchCallback = { [weak self] in
            self?.viewModel.fetchUserNotifications(fromStart: false)
        }

        viewModel.fetchUserNotifications(fromStart: true)
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if UIApplication.shared.applicationIconBadgeNumber > 0 || tabBarController?.tabBar.subview(ofType: BadgeView.self) != nil {
            UIApplication.shared.applicationIconBadgeNumber = 0
            viewModel.fetchUserNotifications(fromStart: true)
        }
    }
    
    public override func loadView() {
        view = NotificationsView()
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    public override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        updateTitleView(size: size)
    }
    
    /**
     Configure a notification cell at an index path.
     
     - parameter cell: The cell to configure.
     - parameter indexPath: The index path of the cell.
     */
    public func configureCell(_ cell: NotificationTableViewCell, at indexPath: IndexPath) {
        cell.configure(with: viewModel.userNotificationViewModel(at: indexPath))
    }
    
    deinit {
        removeDidChangeThemeObserver()
    }
    
}

// MARK: - UserNotificationsViewModel UI Delegate

extension NotificationsViewController: UserNotificationsViewModelUIDelegate {
    public func didFailToFetchUserNotifications(with error: UserNotificationError) {
        if dataSource.isEmpty {
            dataSource.emptyViewDescription = EmptyViewDescription.noLoad
            notificationsView.tableView.reloadData()
        } else {
            showToast(Strings.error.couldNotConnect, severity: .urgent)
        }
    }
    
    public func fetchUserNotificationsDidSucceed(with count: Int, fromStart: Bool) {
        dataSource.emptyViewDescription = emptyViewDescription
        dataSource.totalCount = viewModel.totalCount
        
        if fromStart {
            dataSource.rowCount = count
            notificationsView.tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
        } else {
            let newIndexPaths = dataSource.incrementCount(count)
            notificationsView.tableView.insertRows(at: newIndexPaths, with: .none)
        }
        
        (self.tabBarController as? NLTabBarController)?.removeBadge()
    }

    public func didBeginFetchingUserNotifications(fromStart: Bool) {
        if fromStart && !refreshControl.isRefreshing && dataSource.isEmpty {
            notificationsView.tableView.contentOffset = CGPoint(x: 0, y: -refreshControl.frame.size.height)  // fix refresh control tint bug.
            refreshControl.beginRefreshing()
        }
    }
    
    public func didEndFetchingUserNotifications() {
        if refreshControl.isRefreshing {
            refreshControl.endRefreshing()
        }
    }
    
}

// MARK: - UITableView Delegate

extension NotificationsViewController: UITableViewDelegate {
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if refreshControl.isRefreshing {
            viewModel.fetchUserNotifications(fromStart: true)
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
