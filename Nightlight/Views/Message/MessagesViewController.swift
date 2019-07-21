import UIKit

public class MessagesViewController: UIViewController {

    private let viewModel: MessagesViewModel
    
    public weak var delegate: MessagesViewControllerDelegate?
    
    private var messagesView: MessagesView {
        return view as! MessagesView
    }
    
    private let refreshControl = UIRefreshControl()
    
    public var emptyViewDescription: EmptyViewDescription?
    
    private let dataSource: TableViewArrayPaginatedDataSource<MessageTableViewCell>
    
    init(viewModel: MessagesViewModel) {
        self.viewModel = viewModel
        self.dataSource = TableViewArrayPaginatedDataSource(reuseIdentifier: MessageTableViewCell.className)
        
        super.init(nibName: nil, bundle: nil)
        
        self.dataSource.cellDelegate = self
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        addDidChangeThemeObserver()
        
        updateColors(for: theme)
        
        messagesView.tableView.delegate = self
        messagesView.tableView.dataSource = dataSource
        messagesView.tableView.prefetchDataSource = dataSource
        messagesView.tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        
        dataSource.prefetchCallback = { [weak self] in
            self?.loadMoreMessages()
        }

        self.refreshControl.beginRefreshing()
        refresh()
    }
    
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
                self.showToast("Could not connect to Nightlight.", severity: .urgent)
            }
        }
    }
    
    public func reloadSelectedIndexPath(with message: MessageViewModel) {
        guard let selectedIndexPath = messagesView.tableView.indexPathForSelectedRow
            else { return }
        
        dataSource.data[selectedIndexPath.row] = message
        messagesView.tableView.reloadRows(at: [selectedIndexPath], with: .automatic)
    }
    
    @objc private func refresh() {
        loadMoreMessages(fromStart: true)
    }
    
    public override func loadView() {
        view = MessagesView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        removeDidChangeThemeObserver()
    }
}

// MARK: - MessageTableViewCell Delegate

extension MessagesViewController: MessageTableViewCellDelegate {
    public func cellDidTapAppreciate(_ cell: UITableViewCell) {
        print("appreciate")
    }
    
    public func cellDidTapSave(_ cell: UITableViewCell) {
        guard let indexPath = messagesView.tableView.indexPath(for: cell) else {
            return
        }
        
        let viewModel = dataSource.data[indexPath.row]

        viewModel.saveMessage { [weak self] result in
            self?.handleMessageAction(at: indexPath, result: result)
        }
    }
    
    public func cellDidTapContext(_ cell: UITableViewCell) {
        guard let indexPath = messagesView.tableView.indexPath(for: cell) else {
            return
        }
        
        let viewModel = dataSource.data[indexPath.row]

        delegate?.messagesViewController(self, moreContextFor: viewModel)
    }
    
    public func cellDidTapLove(_ cell: UITableViewCell) {
        guard let indexPath = messagesView.tableView.indexPath(for: cell) else {
            return
        }
        
        let viewModel = dataSource.data[indexPath.row]
        
        viewModel.loveMessage { [weak self] result in
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
        delegate?.messagesViewController(self, didSelect: dataSource.data[indexPath.row])
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
            messagesView.tableView.emptyView?.image = UIImage(named: "empty_message_light")
        case .dark:
            messagesView.tableView.emptyView?.image = UIImage(named: "empty_message_dark")
        }
    }
}
