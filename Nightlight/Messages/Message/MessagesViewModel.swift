import Foundation

/// A view model for handling messages.
public class MessagesViewModel {
    public typealias Dependencies = MessageServiced & StyleManaging
    
    /// The delegate object that handles user interface updates.
    public weak var uiDelegate: MessagesViewModelUIDelegate?
    
    /// The delegate object that handles navigation events.
    public weak var navigationDelegate: MessagesNavigationDelegate?
    
    /// The required dependencies.
    private let dependencies: Dependencies
    
    /// The active theme.
    public var theme: Theme {
        return dependencies.styleManager.theme
    }
    
    /// The type of message to handle.
    public let type: MessageType
    
    /// The fetched messages.
    private var messages = [Message]()
    
    /// The start page for loading messages.
    private var startPage: String?
    
    /// The end page for loading messages.
    private var endPage: String?
    
    /// The total number of messages.
    private(set) var totalCount: Int = 0
    
    /// A boolean for determing if messages are already being fetched.
    private var isFetchInProgress = false
    
    public init(dependencies: Dependencies, type: MessageType) {
        self.dependencies = dependencies
        self.type = type
    }
    
    /**
     Retrieve messages.
     
     - parameter fromStart: A boolean denoting if the data is being fetched from the beginning of a paginated list.
     */
    public func fetchMessages(fromStart: Bool) {
        if fromStart { resetPaging() }
        
        guard !isFetchInProgress && (endPage != nil || startPage == nil) else {
            return
        }

        isFetchInProgress = true
        uiDelegate?.didBeginFetchingMessages(fromStart: fromStart)
        
        dependencies.messageService.getMessages(type: self.type, start: startPage, end: endPage) { [weak self] messageResult in
            guard let self = self else { return }
            self.isFetchInProgress = false
            
            switch messageResult {
            case .success(let messageResponse):
                self.startPage = messageResponse.metadata.start
                self.endPage = messageResponse.metadata.end
                self.totalCount = messageResponse.metadata.total
                
                self.messages = fromStart ? messageResponse.data : self.messages + messageResponse.data
                
                DispatchQueue.main.async { self.uiDelegate?.didFetchMessages(with: messageResponse.data.count, fromStart: fromStart) }
            case .failure(let error):
                DispatchQueue.main.async { self.uiDelegate?.didFailToFetchMessages(with: error) }
            }
            
            DispatchQueue.main.async { self.uiDelegate?.didEndFetchingMessages() }
        }
    }
    
    /**
     Returns a message as a `MessageViewModel` at a specified indexPath.
     
     - parameter indexPath: The index path for the message.
     */
    public func messageViewModel(at indexPath: IndexPath) -> MessageViewModel {
        return MessageViewModel(message: messages[indexPath.row], type: type, dependencies: dependencies)
    }
    
    /**
     Select a message at a specified indexPath.
     
     - parameter indexPath: The index path of the message.
     */
    public func selectMessage(at indexPath: IndexPath) {
        navigationDelegate?.showDetail(message: messages[indexPath.row], at: indexPath)
    }
    
    /**
     Loves a message at a specified index path.
     
     - parameter indexPath: The index path of the message.
     */
    public func loveMessage(at indexPath: IndexPath) {
        let message = messages[indexPath.row]

        dependencies.messageService.love(message: message) { [weak self] loveResult in
            switch loveResult {
            case .success(let message):
                DispatchQueue.main.async { self?.didUpdate(message: message, at: indexPath) }
            case .failure(let error):
                DispatchQueue.main.async { self?.uiDelegate?.didFailToPerformMessage(action: .love, with: error, at: indexPath) }
            }
        }
    }
    
    /**
     Appreciates a message at a specified index path.
     
     - parameter indexPath: The index path of the message.
     */
    public func appreciateMessage(at indexPath: IndexPath) {
        let message = messages[indexPath.row]
        
        if !message.isAppreciated {
//            navigationDelegate?.showAppreciationSheet(for: messages[indexPath.row], at: indexPath)
            dependencies.messageService.appreciate(message: message) { [weak self] (appreciateResult) in
                guard let self = self else { return }
                switch appreciateResult {
                case .success(let message):
                    DispatchQueue.main.async { [weak self] in
                        self?.didUpdate(message: message, at: indexPath)
                    }
                case .failure(let error):
                    DispatchQueue.main.async { [weak self] in
                        self?.uiDelegate?.didFailToPerformMessage(action: .appreciate, with: error, at: indexPath)
                    }
                }
            }
        }
    }
    
    /**
     Saves a message at a specified index path.
     
     - parameter indexPath: The index path of the message.
     */
    public func saveMessage(at indexPath: IndexPath) {
        let message = messages[indexPath.row]
        
        dependencies.messageService.save(message: message) { [weak self] saveResult in
            switch saveResult {
            case .success(let message):
                DispatchQueue.main.async { self?.didUpdate(message: message, at: indexPath) }
            case .failure(let error):
                DispatchQueue.main.async { self?.uiDelegate?.didFailToPerformMessage(action: .save, with: error, at: indexPath) }
            }
        }
    }
    
    /**
     Shows a context menu for a message at a specified index path.
     
     - parameter indexPath: The index path of the message.
     */
    public func contextForMessage(at indexPath: IndexPath) {
        var actions: [MessageContextAction] = [.report]
        
        if dependencies.messageService.isDeleteable(message: messages[indexPath.row], type: type) {
            actions.append(.delete)
        }

        navigationDelegate?.showContextMenu(for: messages[indexPath.row], with: actions, at: indexPath)
    }
    
    /**
     Deletes a message at a specified index path.
     
     - parameter indexPath: The index path of the message.
     */
    public func deleteMessage(at indexPath: IndexPath) {
        dependencies.messageService.deleteMessage(with: messages[indexPath.row].id) { [weak self] deleteResult in
            switch deleteResult {
            case .success:
                DispatchQueue.main.async { self?.didDeleteMessage(at: indexPath) }
            case .failure(let error):
                DispatchQueue.main.async { self?.uiDelegate?.didFailToDeleteMessage(with: error, at: indexPath) }
            }
        }
    }
 
    /**
     Resets the paging.
     
     Causes messages to be fetched from the beginning.
     */
    public func resetPaging() {
        startPage = nil
        endPage = nil
    }
    
}

// MARK: - Navigation Events

extension MessagesViewModel {
    public func didUpdate(message: Message, at indexPath: IndexPath) {
        messages[indexPath.row] = message
        uiDelegate?.didUpdateMessage(at: indexPath)
    }
    
    public func didDeleteMessage(at indexPath: IndexPath) {
        messages.remove(at: indexPath.row)
        uiDelegate?.didDeleteMessage(at: indexPath)
    }
    
    public func didFailToAppreciateMessage(with error: MessageError, at indexPath: IndexPath) {
        uiDelegate?.didFailToPerformMessage(action: .appreciate, with: error, at: indexPath)
    }
    
    public func didFinishPresentingContextMenu(with option: MessageContextAction, at indexPath: IndexPath) {
        switch option {
        case .report:
            uiDelegate?.didReportMessage(at: indexPath)
        case .delete:
            deleteMessage(at: indexPath)
        }
    }

}
