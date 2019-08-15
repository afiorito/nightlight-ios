import Foundation
import StoreKit

/// A view model for handling a message.
public class MessageViewModel {
    public typealias MessageResultCompletion = (Result<MessageViewModel, MessageError>) -> Void
    public typealias Dependencies = KeychainManaging & MessageServiced & IAPManaging
    public typealias MessageAppreciateResult = Result<MessageAppreciateResponse, MessageError>
    
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
    
    public init(dependencies: Dependencies, message: Message, type: MessageType) {
        self.dependencies = dependencies
        self.message = message
        self.type = type
    }
    
    /**
     Loves a message.
     
     - parameter result: The result of loving a message.
     */
    public func loveMessage(result: @escaping MessageResultCompletion) {
        dependencies.messageService.actionMessage(with: message.id, type: .love) { (loveResult: Result<MessageLoveResponse, MessageError>) in
            switch loveResult {
            case .success(let loveResponse):
                
                self.message.isLoved = loveResponse.isLoved
                self.message.loveCount = max(0, self.message.loveCount + (loveResponse.isLoved ? 1 : -1))
                
                DispatchQueue.main.async {
                    result(.success(self))
                    
                }
                
            case .failure:
                DispatchQueue.main.async { result(.failure(.unknown)) }
            }
        }
    }
    
    /**
     Saves a message.
     
     - parameter result: The result of saving a message.
     */
    public func saveMessage(result: @escaping MessageResultCompletion) {
        dependencies.messageService.actionMessage(with: message.id, type: .save) { (saveResult: Result<MessageSaveResponse, MessageError>) in
            switch saveResult {
            case .success(let saveResponse):
                
                self.message.isSaved = saveResponse.isSaved

                DispatchQueue.main.async {
                    result(.success(self))
                }
                
            case .failure:
                DispatchQueue.main.async { result(.failure(.unknown)) }
            }
        }
    }
    
    /**
     Appreciates a message.
     
     - parameter result: The result of appreciating a message.
     */
    public func appreciateMessage(result: @escaping MessageResultCompletion) {
        dependencies.messageService.actionMessage(with: message.id, type: .appreciate) { [weak self] (appreciateResult: MessageAppreciateResult) in
            guard let self = self else { return }

            switch appreciateResult {
            case .success(let appreciateResponse):
                if appreciateResponse.isAppreciated {
                    self.message.appreciationCount += 1
                    self.message.isAppreciated = true
                    let tokens = (try? self.dependencies.keychainManager.integer(forKey: KeychainKey.tokens.rawValue)) ?? 0
                    try? self.dependencies.keychainManager.set(tokens - 100, forKey: KeychainKey.tokens.rawValue)
                }
                
                DispatchQueue.main.async { result(.success(self)) }
            case .failure(let error):
                DispatchQueue.main.async { result(.failure(error)) }
                
            }
        }
    }
    
    /**
     Deletes a message.
     
     - parameter result: The result of deleting a message.
     */
    public func delete(result: @escaping (Result<MessageViewModel, MessageError>) -> Void) {
        dependencies.messageService.deleteMessage(with: message.id) { deleteResult in
            switch deleteResult {
            case .success:
                DispatchQueue.main.async {
                    result(.success(MessageViewModel(dependencies: self.dependencies, message: self.message, type: self.type)))
                }
            case .failure:
                DispatchQueue.main.async { result(.failure(.unknown)) }
            }
        }
    }
}
