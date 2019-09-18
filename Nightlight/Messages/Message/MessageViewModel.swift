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
    private(set) var message: Message
    
    /// The type of message being handled.
    public let type: MessageType
    
    /// The title of the message.
    public var title: String {
        return message.title
    }
    
    /// The username of the message.
    public var username: String {
        return message.user.username
    }
    
    /// The display name of the sender.
    public var displayName: String {
        return message.isAnonymous ? "anonymous" : message.user.username
    }
    
    /// The time since the message is posted.
    public var timeAgo: String {
        return " · \(message.createdAt.ago())"
    }
    
    /// The body of the message.
    public var body: String {
        return "\(message.body)"
    }
    
    /// The total love a message has received.
    public var loveCount: Int {
        return message.loveCount
    }
    
    /// The total appreciation a message has received.
    public var appreciationCount: Int {
        return message.appreciationCount
    }
    
    /// A boolean representing if the message is already loved.
    public var isLoved: Bool {
        return message.isLoved
    }
    
    /// A boolean representing if the message is already appreciated.
    public var isAppreciated: Bool {
        return message.isAppreciated
    }
    
    /// A boolean representing if the message is already saved.
    public var isSaved: Bool {
        return message.isSaved
    }
    
    public init(message: Message, type: MessageType, dependencies: Dependencies) {
        self.message = message
        self.type = type
        self.dependencies = dependencies
    }
    
    /**
     Loves a message.
     */
    public func loveMessage() {
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
                DispatchQueue.main.async { self.uiDelegate?.didFailToPerformMessage(action: .save, with: error) }
            }
        }
    }
    
    /**
     Appreciates a message.
     */
    public func appreciateMessage() {
        if !message.isAppreciated {
            navigationDelegate?.showAppreciationSheet(for: message)
        }
    }
    
    /**
     Shows a context menu for the message.
     */
    public func contextForMessage() {
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
        dependencies.messageService.deleteMessage(with: message.id) { [weak self] deleteResult in
            guard let self = self else { return }
            switch deleteResult {
            case .success:
                DispatchQueue.main.async {
                    self.navigationDelegate?.didDelete(message: self.message)
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
