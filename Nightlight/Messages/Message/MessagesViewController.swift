import UIKit

/// A view controller for managing a list of messages.
public class MessagesViewController: UIViewController {
    /// The viewModel for handling state.
    private let viewModel: MessagesViewModel
    
    /// The delegate for managing UI actions.
    public weak var delegate: MessagesViewControllerDelegate?
    
    private var messagesView: MessagesView {
        return view as! MessagesView
    }
    
    /// a refresh control for messages.
    private let refreshControl = UIRefreshControl()
    
    /// a view displayed when the messages list is empty.
    public var emptyViewDescription: EmptyViewDescription?
    
    // the object that acts as the data source of the table view.
    private let dataSource: TableViewArrayPaginatedDataSource<MessageTableViewCell>
    
    init(viewModel: MessagesViewModel) {
        self.viewModel = viewModel
        self.dataSource = TableViewArrayPaginatedDataSource(reuseIdentifier: MessageTableViewCell.className)
        
        super.init(nibName: nil, bundle: nil)
        self.dataSource.cellDelegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: View Controller Lifecycle
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        addDidChangeThemeObserver()
        
        updateColors(for: theme)
        
        messagesView.tableView.delegate = self
        messagesView.tableView.dataSource = dataSource
        messagesView.tableView.prefetchDataSource = dataSource
        messagesView.tableView.refreshControl = refreshControl
        
        self.dataSource.emptyViewDescription = self.emptyViewDescription
        
        dataSource.prefetchCallback = { [weak self] in
            self?.loadMoreMessages()
        }

        self.refreshControl.beginRefreshing()
        refresh()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // deselect row upon returning to the view controller.
        if let selectedIndexPath = messagesView.tableView.indexPathForSelectedRow {
            messagesView.tableView.deselectRow(at: selectedIndexPath, animated: true)
        }
    }
    
    public override func loadView() {
        view = MessagesView()
    }
    
    /**
     Requests more messages to be displayed.
     
     - parameter fromStart: A boolean that determines if messages are loaded from the beginning of the list or appended to the current list.
     */
    private func loadMoreMessages(fromStart: Bool = false) {
        if fromStart { viewModel.resetPaging() }
        
        viewModel.getMessages { [weak self] result in
            guard let self = self else { return }
            
            if self.refreshControl.isRefreshing {
                self.refreshControl.endRefreshing()
            }
            
            switch result {
            case .success(let messages):
                self.dataSource.emptyViewDescription = self.emptyViewDescription
                self.dataSource.totalCount = self.viewModel.totalCount
                
                if fromStart {
                    self.dataSource.data = messages
                    self.messagesView.tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
                } else {
                    let newIndexPaths = self.dataSource.updateData(with: messages)
                    self.messagesView.tableView.insertRows(at: newIndexPaths, with: .none)
                }
                
            case .failure:
                // ensure empty view is updated properly.
                if self.dataSource.data.isEmpty {
                    self.dataSource.emptyViewDescription = EmptyViewDescription.noLoad
                    self.messagesView.tableView.reloadData()
                }
                self.showToast(Strings.error.couldNotConnect, severity: .urgent)
            }
        }
    }
    
    /**
     Refresh the table view.
     */
    @objc private func refresh() {
        loadMoreMessages(fromStart: true)
    }
    
    deinit {
        removeDidChangeThemeObserver()
    }
}

// MARK: - Message Events

extension MessagesViewController: MessageContextHandling {
    public func didReportMessage(message: MessageViewModel, at indexPath: IndexPath) {
        showToast(Strings.message.reported, severity: .success)
    }
    
    public func didDeleteMessage(message: MessageViewModel, at indexPath: IndexPath) {
        message.delete { [weak self] result in
            switch result {
            case .success:
                self?.dataSource.data.remove(at: indexPath.row)
                self?.messagesView.tableView.deleteRows(at: [indexPath], with: .automatic)
            case .failure:
                self?.showToast(Strings.error.couldNotConnect, severity: .urgent)
            }
        }
    }
    
    public func didUpdateMessage(_ message: MessageViewModel, at indexPath: IndexPath) {
        self.dataSource.data[indexPath.row] = message
        self.messagesView.tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}

// MARK: - Appreciation Event Handling

extension MessagesViewController: AppreciationEventHandling {
    public func didAppreciateMessage(at indexPath: IndexPath) {
        let viewModel = self.dataSource.data[indexPath.row]
        
        viewModel.appreciateMessage { [weak self] result in
            guard let self = self else { return }
            
            self.delegate?.messagesViewControllerAppreciation(self, didComplete: true)
            
            switch result {
            case .success(let message):
                self.didUpdateMessage(message, at: indexPath)
            case .failure(let error):
                self.showToast(error.message, severity: .urgent)
                
            }
        }
    }
}

// MARK: - MessageTableViewCell Delegate

extension MessagesViewController: MessageTableViewCellDelegate {
    public func cellDidTapAppreciate(_ cell: MessageTableViewCell) {
        guard let indexPath = messagesView.tableView.indexPath(for: cell) else {
            return
        }

        delegate?.messagesViewController(self, didAppreciate: dataSource.data[indexPath.row], at: indexPath)
    }
    
    public func cellDidTapSave(_ cell: MessageTableViewCell) {
        guard let indexPath = messagesView.tableView.indexPath(for: cell) else {
            return
        }

        dataSource.data[indexPath.row].saveMessage { [weak self] result in
            self?.handleMessageAction(at: indexPath, result: result)
        }
    }
    
    public func cellDidTapContext(_ cell: MessageTableViewCell) {
        guard let indexPath = messagesView.tableView.indexPath(for: cell) else {
            return
        }

        delegate?.messagesViewController(self, moreContextFor: dataSource.data[indexPath.row], at: indexPath)
    }
    
    public func cellDidTapLove(_ cell: MessageTableViewCell) {
        guard let indexPath = messagesView.tableView.indexPath(for: cell) else {
            return
        }
        
        dataSource.data[indexPath.row].loveMessage { [weak self] result in
            self?.handleMessageAction(at: indexPath, result: result)
        }
    }
    
    private func handleMessageAction(at indexPath: IndexPath, result: Result<MessageViewModel, MessageError>) {
        switch result {
        case .success(let message):
            self.dataSource.data[indexPath.row] = message
        case .failure:
            self.showToast("Could not connect to Nightlight.", severity: .urgent)
        }
        
        self.messagesView.tableView.reloadRows(at: [indexPath], with: .none)
    }
    
}

// MARK: - UITableViewDelegate

extension MessagesViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.messagesViewController(self, didSelect: dataSource.data[indexPath.row], at: indexPath)
    }
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if refreshControl.isRefreshing {
            refresh()
        }
    }
}

// MARK: - Themeable

extension MessagesViewController: Themeable {
    var theme: Theme {
        return viewModel.theme
    }
    
    public func updateColors(for theme: Theme) {
        view.backgroundColor = .background(for: theme)
        messagesView.updateColors(for: theme)
        toastView?.updateColors(for: theme)
        messagesView.tableView.emptyView?.updateColors(for: theme)
        refreshControl.tintColor = .neutral
        
        switch theme {
        case .light:
            messagesView.tableView.emptyView?.image = UIImage.empty.messageLight
        case .dark:
            messagesView.tableView.emptyView?.image = UIImage.empty.messageDark
        }
        
        (navigationItem.titleView as? Themeable)?.updateColors(for: theme)
    }
}
