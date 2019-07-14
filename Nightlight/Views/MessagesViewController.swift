import UIKit

public class MessagesViewController: UIViewController, Themeable {

    private let viewModel: MessagesViewModel
    
    private var messagesView: MessagesView {
        return view as! MessagesView
    }
    
    private let refreshControl = UIRefreshControl()
    
    public var emptyViewDescription: EmptyViewDescription? {
        get {
            return dataSource.emptyViewDescription
        }
        
        set {
            dataSource.emptyViewDescription = newValue
        }
    }
    
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
        
        updateColors(for: viewModel.theme)
        
        messagesView.tableView.dataSource = dataSource
        messagesView.tableView.prefetchDataSource = dataSource
        messagesView.tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        
        dataSource.prefetchCallback = { [weak self] in
            self?.loadMoreMessages()
        }
        
        loadMoreMessages(fromStart: true)
    }
    
    private func loadMoreMessages(fromStart: Bool = false) {
        if fromStart { viewModel.resetPaging() }
        
        viewModel.getMessages { [weak self] result in
            guard let self = self else { return }
            
            self.refreshControl.endRefreshing()
            
            if let description = self.emptyViewDescription {
                self.messagesView.tableView.showEmptyViewIfNeeded(emptyViewDescription: description)
                self.messagesView.updateColors(for: self.viewModel.theme)
            }
            
            switch result {
            case .success(let messages):
                self.dataSource.totalCount = self.viewModel.totalCount
                
                if fromStart {
                    self.dataSource.data = messages
                    self.messagesView.tableView.reloadData()
                } else {
                    let newIndexPaths = self.dataSource.updateData(with: messages)
                    self.messagesView.tableView.insertRows(at: newIndexPaths, with: .none)
                }
                
            case .failure(let error):
                let toast = self.showToast("\(error)", severity: .urgent)
                toast.updateColors(for: self.viewModel.theme)
            }
        }
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
    
    public func updateColors(for theme: Theme) {
        view.backgroundColor = .background(for: theme)
        messagesView.updateColors(for: theme)
    }

}

extension MessagesViewController: MessageTableViewCellDelegate {
    public func cellDidTapAppreciate(_ cell: UITableViewCell) {
        print("appreciate")
    }
    
    public func cellDidTapSave(_ cell: UITableViewCell) {
        print("save")
    }
    
    public func cellDidTapContext(_ cell: UITableViewCell) {
        print("context")
    }
    
    public func cellDidTapLove(_ cell: UITableViewCell) {
        print("love")
    }
    
}
