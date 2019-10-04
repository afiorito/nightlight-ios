import UIKit

/// A view controller for managing a message detail.
public class MessageDetailViewController: UIViewController {
    /// The viewModel for handling state.
    private let viewModel: MessageViewModel
    
    /// A container scroll view for handling long content.
    private let scrollView = UIScrollView()
    
    /// The contentView of the scroll view.
    private let contentView = UIView()
    
    /// The view that the `MessageDetailViewController` manages.
    public let messageContentView = MessageContentView()
    
    /// An activity indicator while the message is loading.
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.hidesWhenStopped = true
        indicator.style = .gray
        
        return indicator
    }()
    
    public init(viewModel: MessageViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        title = Strings.message.detailTitle
        
        addDidChangeThemeObserver()
        
        messageContentView.loveAction.button.addTarget(self, action: #selector(loveTapped), for: .touchUpInside)
        messageContentView.appreciateAction.button.addTarget(self, action: #selector(appreciateTapped), for: .touchUpInside)
        messageContentView.saveAction.button.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
        messageContentView.contextButton.addTarget(self, action: #selector(contextTapped), for: .touchUpInside)
        
        updateView()
        prepareSubviews()
        updateColors(for: theme)
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        navigationController?.setStyle(.secondary, for: theme)
        super.viewWillAppear(animated)
    }
    
    public func updateView() {
        if viewModel.isLoading {
            activityIndicator.startAnimating()
        }
        
        messageContentView.isHidden = viewModel.isLoading
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
        contentView.addSubviews(activityIndicator)
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
            activityIndicator.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 32),
            activityIndicator.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            messageContentView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            messageContentView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            messageContentView.leadingAnchor.constraint(equalTo: contentView.readableContentGuide.leadingAnchor, constant: 15),
            messageContentView.trailingAnchor.constraint(equalTo: contentView.readableContentGuide.trailingAnchor, constant: -15)
        ])
    }
    
    // MARK: - Gesture Recognizer Handlers
    
    @objc private func loveTapped() {
        viewModel.loveMessage()
    }
    
    @objc private func appreciateTapped() {
        viewModel.appreciateMessage()
    }
    
    @objc private func saveTapped() {
        viewModel.saveMessage()
    }
    
    @objc private func contextTapped() {
        viewModel.contextForMessage()
    }
    
    deinit {
        removeDidChangeThemeObserver()
    }
}

// MARK: - MessageViewModel UI Delegate

extension MessageDetailViewController: MessageViewModelUIDelegate {
    public func didFetchMessage() {
        updateView()
    }

    public func didBeginFetchingMessage() {
        activityIndicator.startAnimating()
    }
    
    public func didEndFetchingMessage() {
        activityIndicator.stopAnimating()
    }
    
    public func didFailToFindMessage() {
        showEmptyView(description: .messageNotFound)
    }
    
    public func didFailToFetchMessage() {
        showEmptyView(description: .noLoad)
    }
    
    public func didFailToDeleteMessage(with error: MessageError) {
        showToast(Strings.error.couldNotConnect, severity: .urgent)
    }
    
    public func didReportMessage() {
        showToast(Strings.message.reported, severity: .success)
    }
    
    public func didUpdateMessage() {
        updateView()
    }
    
    public func didFailToPerformMessage(action: MessageActionType, with error: MessageError) {
        updateView()
        showToast(error.message, severity: .urgent)
    }

}

// MARK: EmptyViewable

extension MessageDetailViewController: EmptyViewable {
    public var emptyView: EmptyView? {
        return view.subview(ofType: EmptyView.self)
    }

    public func showEmptyView(description: EmptyViewDescription) {
        emptyView?.removeFromSuperview()
        
        let emptyView = EmptyView(description: description)
        view.addSubviews(emptyView)
        
        NSLayoutConstraint.activate([
            emptyView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            emptyView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15)
        ])
    }
    
    public func hideEmptyView() {
        emptyView?.removeFromSuperview()
    }

}

// MARK: - Themeable

extension MessageDetailViewController: Themeable {
    public func updateColors(for theme: Theme) {
        view.backgroundColor = .background(for: theme)
        messageContentView.updateColors(for: theme)
        activityIndicator.color = .gray(for: theme)
    }
}
