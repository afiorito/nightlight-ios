import UIKit

public class MessageDetailViewController: UIViewController {

    private let viewModel: MessageViewModel
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let messageContentView = MessageContentView()
    
    public weak var delegate: MessageDetailViewControllerDelegate?
    
    init(viewModel: MessageViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        (navigationController as? Themeable)?.updateColors(for: theme)
        
        super.viewWillAppear(animated)
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Message"
        
        addDidChangeThemeObserver()
        
        messageContentView.loveAction.button.addTarget(self, action: #selector(loveTapped), for: .touchUpInside)
        messageContentView.appreciateAction.button.addTarget(self, action: #selector(appreciateTapped), for: .touchUpInside)
        messageContentView.saveAction.button.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
        messageContentView.contextButton.addTarget(self, action: #selector(contextTapped), for: .touchUpInside)
        
        updateView()
        
        updateColors(for: theme)
        
        prepareSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        removeDidChangeThemeObserver()
    }
    
    @objc private func loveTapped() {
        viewModel.loveMessage { [weak self] result in
            self?.handleMessageAction(result: result)
        }
    }
    
    @objc private func appreciateTapped() {
        delegate?.messageDetailViewController(self, didAppreciate: viewModel)
    }
    
    @objc private func saveTapped() {
        viewModel.saveMessage { [weak self] result in
            self?.handleMessageAction(result: result)
        }
    }
    
    @objc private func contextTapped() {
        delegate?.messageDetailViewController(self, moreContextFor: viewModel)
    }
    
    private func handleMessageAction(result: Result<MessageViewModel, MessageError>) {
        switch result {
        case .success:
            delegate?.messageDetailViewController(self, didUpdate: viewModel)
        case .failure:
            self.showToast("Could not connect to Nightlight.", severity: .urgent)
        }
        
        updateView()
    }
    
    private func updateView() {
        messageContentView.titleLabel.text = viewModel.title
        messageContentView.usernameLabel.text = viewModel.displayName
        messageContentView.timeAgoLabel.text = viewModel.timeAgo
        messageContentView.bodyLabel.text = viewModel.body
        messageContentView.loveAction.isSelected = viewModel.isLoved
        messageContentView.loveAction.count = viewModel.loveCount
        messageContentView.appreciateAction.isSelected = viewModel.isAppreciated
        messageContentView.appreciateAction.count = viewModel.appreciationCount
        messageContentView.saveAction.isSelected = viewModel.isSaved
    }
    
    private func prepareSubviews() {
        view.addSubviews(scrollView)
        contentView.addSubviews([messageContentView])
        scrollView.addSubviews(contentView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: view.widthAnchor),
            messageContentView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            messageContentView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            messageContentView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            messageContentView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15)
        ])
    }

}

// MARK: - MessageEventHandling

extension MessageDetailViewController: MessageContextHandling {
    public func didReportMessage(message: MessageViewModel, at indexPath: IndexPath) {
        showToast("The message has been reported!", severity: .success)
    }
    
    public func didDeleteMessage(message: MessageViewModel, at indexPath: IndexPath) {
        self.delegate?.messageDetailViewController(self, didDelete: message)
    }
}

extension MessageDetailViewController: AppreciationEventHandling {
    public func didAppreciateMessage(at indexPath: IndexPath) {
        viewModel.appreciateMessage { [weak self] result in
            guard let self = self else { return }
            
            self.delegate?.messageDetailViewControllerAppreciation(self, didComplete: true)
            
            switch result {
            case .success:
                self.delegate?.messageDetailViewController(self, didUpdate: self.viewModel)
                self.updateView()
            case .failure(let error):
                self.showToast(error.message, severity: .urgent)
                
            }
        }
    }
}

// MARK: - Themeable

extension MessageDetailViewController: Themeable {
    public func updateColors(for theme: Theme) {
        view.backgroundColor = .background(for: theme)
        messageContentView.updateColors(for: theme)
    }
}
