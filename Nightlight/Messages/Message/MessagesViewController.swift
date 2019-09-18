import UIKit

/// A view controller for managing a list of messages.
public class MessagesViewController: UIViewController {
    /// The viewModel for handling state.
    private let viewModel: MessagesViewModel
    
    /// The view that the `MessagesViewController` manages.
    private var messagesView: MessagesView {
        return view as! MessagesView
    }
    
    /// A refresh control for messages.
    private let refreshControl = UIRefreshControl()
    
    /// A view displayed when the messages list is empty.
    public var emptyViewDescription: EmptyViewDescription?
    
    /// The object that acts as the data source of the table view.
    private lazy var dataSource: SimpleTableViewPaginatedDataSource<MessageTableViewCell> = {
        SimpleTableViewPaginatedDataSource(reuseIdentifier: MessageTableViewCell.className, cellConfigurator: configureCell)
    }()
    
    public init(viewModel: MessagesViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Controller Lifecycle
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        addDidChangeThemeObserver()
        
        updateColors(for: theme)
        
        addTitleView()
        
        messagesView.tableView.delegate = self
        messagesView.tableView.dataSource = dataSource
        messagesView.tableView.prefetchDataSource = dataSource
        messagesView.tableView.refreshControl = refreshControl
        
        dataSource.prefetchCallback = { [weak self] in
            self?.viewModel.fetchMessages(fromStart: false)
        }

        viewModel.fetchMessages(fromStart: true)
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        styleNavigationController(for: theme)
        
        // deselect row upon returning to the view controller.
        if let selectedIndexPath = messagesView.tableView.indexPathForSelectedRow {
            messagesView.tableView.deselectRow(at: selectedIndexPath, animated: true)
        }
    }
    
    public override func loadView() {
        view = MessagesView()
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    public override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        updateTitleView(size: size)
    }
    
    /**
     Configure a message cell at an index path.
     
     - parameter cell: The cell to configure.
     - parameter indexPath: The index path of the cell.
     */
    public func configureCell(_ cell: MessageTableViewCell, at indexPath: IndexPath) {
        cell.configure(with: viewModel.messageViewModel(at: indexPath))
        
        cell.loveAction = { [weak self] in self?.viewModel.loveMessage(at: indexPath) }
        cell.appreciateAction = { [weak self] in self?.viewModel.appreciateMessage(at: indexPath) }
        cell.saveAction = { [weak self] in self?.viewModel.saveMessage(at: indexPath) }
        cell.contextAction = { [weak self] in self?.viewModel.contextForMessage(at: indexPath) }
    }
    
    deinit {
        removeDidChangeThemeObserver()
    }
}

// MARK: - MessagesViewModel UI Delegate

extension MessagesViewController: MessagesViewModelUIDelegate {
    
    public func didDeleteMessage(at indexPath: IndexPath) {
        dataSource.rowCount -= 1
        dataSource.totalCount -= 1
        messagesView.tableView.deleteRows(at: [indexPath], with: .automatic)
    }

    public func didFailToDeleteMessage(with error: MessageError, at indexPath: IndexPath) {
        showToast(Strings.error.couldNotConnect, severity: .urgent)
    }
    
    public func didUpdateMessage(at indexPath: IndexPath) {
        messagesView.tableView.reloadRows(at: [indexPath], with: .none)
    }
    
    public func didFailToPerformMessage(action: MessageActionType, with error: MessageError, at indexPath: IndexPath) {
        messagesView.tableView.reloadRows(at: [indexPath], with: .none)
        showToast(error.message, severity: .urgent)
    }
    
    public func didFetchMessages(with count: Int, fromStart: Bool) {
        dataSource.emptyViewDescription = emptyViewDescription
        dataSource.totalCount = viewModel.totalCount
        
        if fromStart {
            dataSource.rowCount = count
            messagesView.tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
        } else {
            let newIndexPaths = dataSource.incrementCount(count)
            messagesView.tableView.insertRows(at: newIndexPaths, with: .none)
        }
    }

    public func didFailToFetchMessages(with error: MessageError) {
        if dataSource.isEmpty {
            dataSource.emptyViewDescription = EmptyViewDescription.noLoad
            messagesView.tableView.reloadData()
        } else {
            showToast(Strings.error.couldNotConnect, severity: .urgent)
        }
    }
    
    public func didReportMessage(at indexPath: IndexPath) {
        showToast(Strings.message.reported, severity: .success)
    }
    
    public func didBeginFetchingMessages(fromStart: Bool) {
        if fromStart && !refreshControl.isRefreshing {
            messagesView.tableView.contentOffset = CGPoint(x: 0, y: -refreshControl.frame.size.height)  // fix refresh control tint bug.
            refreshControl.beginRefreshing()
        }
    }
    
    public func didEndFetchingMessages() {
        if refreshControl.isRefreshing {
            refreshControl.endRefreshing()
        }
    }
}

// MARK: - UITableView Delegate

extension MessagesViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.selectMessage(at: indexPath)
    }
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if refreshControl.isRefreshing {
            viewModel.fetchMessages(fromStart: true)
        }
    }
}

// MARK: - Themeable

extension MessagesViewController: Themeable {
    var theme: Theme {
        return viewModel.theme
    }
    
    public func updateColors(for theme: Theme) {
        styleNavigationController(for: theme)

        view.backgroundColor = .background(for: theme)
        messagesView.updateColors(for: theme)
        toastView?.updateColors(for: theme)
        messagesView.tableView.emptyView?.updateColors(for: theme)
        refreshControl.tintColor = .gray(for: theme)
        messagesView.tableView.emptyView?.image = UIImage.empty.message
        
        (navigationItem.titleView as? Themeable)?.updateColors(for: theme)
    }
    
    private func styleNavigationController(for theme: Theme) {
        guard let navigationController = parent as? UINavigationController else { return }
        navigationController.setStyle(.primary, for: theme)
    }
}
