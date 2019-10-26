import Foundation

/// A view model for handling a message.
public class MessageViewModel {
    public typealias MessageResultCompletion = (Result<MessageViewModel, MessageError>) -> Void
    public typealias Dependencies = StyleManaging & MessageServiced
    private typealias ActionResult<T> = Result<T, MessageError>
    
    /// The delegate object that handles user interface updates.
    public weak var uiDelegate: MessageViewModelUIDelegate?
    
    /// The delegate object that handles navigation events.
    public weak var navigationDelegate: MessageNavigationDelegate?
    
    /// The required dependencies.
    private let dependencies: Dependencies
    
    /// A callback for the completion of purchasing appreciation.
    private var purchaseCompletionHandler: MessageResultCompletion?
    
    /// The backing message model.
    private(set) var message: Message?
    
    /// The type of message being handled.
    public let type: MessageType
    
    /// The title of the message.
    public var title: String {
        return message?.title ?? ""
    }
    
    /// The username of the message.
    public var username: String {
        return message?.user.username ?? ""
    }
    
    /// The display name of the sender.
    public var displayName: String {
        return message?.isAnonymous == true ? "anonymous" : message?.user.username ?? ""
    }
    
    /// The time since the message is posted.
    public var timeAgo: String {
        guard let message = message else { return "" }
        
        return " · \(message.createdAt.ago())"
    }
    
    /// The body of the message.
    public var body: String {
        return message?.body ?? ""
    }
    
    /// The total love a message has received.
    public var loveCount: Int {
        return message?.loveCount ?? 0
    }
    
    /// The total appreciation a message has received.
    public var appreciationCount: Int {
        return message?.appreciationCount ?? 0
    }
    
    /// A boolean representing if the message is already loved.
    public var isLoved: Bool {
        return message?.isLoved ?? false
    }
    
    /// A boolean representing if the message is already appreciated.
    public var isAppreciated: Bool {
        return message?.isAppreciated ?? false
    }
    
    /// A boolean representing if the message is already saved.
    public var isSaved: Bool {
        return message?.isSaved ?? false
    }
    
    public var isLoading: Bool {
        return message == nil
    }
    
    public init(message: Message, type: MessageType, dependencies: Dependencies) {
        self.message = message
        self.type = type
        self.dependencies = dependencies
    }
    
    public init(messageId: Int, dependencies: Dependencies) {
        self.message = nil
        self.type = .recent
        self.dependencies = dependencies
        
        fetchMessage(with: messageId)
    }
    
    /**
     Retrieve a message with a specified id.
     
     - parameter id: the unique id of the message.
     */
    private func fetchMessage(with id: Int) {
        uiDelegate?.didBeginFetchingMessage()
    
        dependencies.messageService.getMessage(with: id) { [weak self] messageResult in
            DispatchQueue.main.async { self?.uiDelegate?.didEndFetchingMessage() }
            
            switch messageResult {
            case .success(let message):
                self?.message = message
                DispatchQueue.main.async { self?.uiDelegate?.didFetchMessage() }
            case .failure(let error):
                switch error {
                case .notFound:
                    DispatchQueue.main.async { self?.uiDelegate?.didFailToFindMessage() }
                default:
                    DispatchQueue.main.async { self?.uiDelegate?.didFailToFetchMessage() }
                }
            }
        }
    }
    
    /**
     Loves a message.
     */
    public func loveMessage() {
        guard let message = message else { return }

        dependencies.messageService.love(message: message) { [weak self] loveResult in
            guard let self = self else { return }
            switch loveResult {
            case .success(let message):
                self.message = message
                DispatchQueue.main.async {
                    self.navigationDelegate?.didUpdate(message: message)
                    self.uiDelegate?.didUpdateMessage()
                }
            case .failure(let error):
                DispatchQueue.main.async { self.uiDelegate?.didFailToPerformMessage(action: .love, with: error) }
            }
        }
    }
    
    /**
     Saves a message.
     */
    public func saveMessage() {
        guard let message = message else { return }

        dependencies.messageService.save(message: message) { [weak self] saveResult in
            guard let self = self else { return }
            
            switch saveResult {
            case .success(let message):
                self.message = message
                DispatchQueue.main.async {
                    self.navigationDelegate?.didUpdate(message: message)
                    self.uiDelegate?.didUpdateMessage()
                }
            case .failure(let error):
                DispatchQueue.main.async { [weak self] in
                    self?.uiDelegate?.didFailToPerformMessage(action: .save, with: error)
                }
            }
        }
    }
    
    /**
     Appreciates a message.
     */
    public func appreciateMessage() {
        guard let message = message else { return }

        if !message.isAppreciated {
            navigationDelegate?.showAppreciationSheet(for: message)
        }
    }
    
    /**
     Shows a context menu for the message.
     */
    public func contextForMessage() {
        guard let message = message else { return }

        var actions: [MessageContextAction] = [.report]
        
        if dependencies.messageService.isDeleteable(message: message, type: type) {
            actions.append(.delete)
        }

        navigationDelegate?.showContextMenu(for: message, with: actions)
    }
    
    /**
     Deletes a message.
     */
    public func delete() {
        guard let message = message else { return }

        dependencies.messageService.deleteMessage(with: message.id) { [weak self] deleteResult in
            guard let self = self else { return }
            switch deleteResult {
            case .success:
                DispatchQueue.main.async {
                    self.navigationDelegate?.didDelete(message: message)
                }
            case .failure(let error):
                DispatchQueue.main.async { self.uiDelegate?.didFailToDeleteMessage(with: error) }
            }
        }
    }
}

// MARK: - Navigation Events

extension MessageViewModel {
    public func didFinishPresentingContextMenu(with action: MessageContextAction) {
        switch action {
        case .report:
            uiDelegate?.didReportMessage()
        case .delete:
            delete()
        }
    }
    
    public func didUpdate(message: Message) {
        self.message = message
        uiDelegate?.didUpdateMessage()
    }
    
    public func didFailToAppreciate(with error: MessageError) {
        uiDelegate?.didFailToPerformMessage(action: .appreciate, with: error)
    }
}
