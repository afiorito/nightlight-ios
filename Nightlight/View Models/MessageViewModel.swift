import Foundation
import StoreKit

public class MessageViewModel {
    public typealias MessageResultCompletion = (Result<MessageViewModel, MessageError>) -> Void
    public typealias Dependencies = KeychainManaging & MessageServiced & IAPManaging
    
    private var purchaseCompletionHandler: MessageResultCompletion?
    
    private let dependencies: Dependencies
    
    private(set) var message: Message
    
    public let type: MessageType
    
    public var title: String {
        return message.title
    }
    
    public var username: String {
        return message.user.username
    }
    
    public var displayName: String {
        return message.isAnonymous ? "anonymous" : message.user.username
    }
    
    public var timeAgo: String {
        return " · \(message.createdAt.ago())"
    }
    
    public var body: String {
        return "\(message.body)"
    }
    
    public var loveCount: Int {
        return message.loveCount
    }
    
    public var appreciationCount: Int {
        return message.appreciationCount
    }
    
    public var isLoved: Bool {
        return message.isLoved
    }
    
    public var isAppreciated: Bool {
        return message.isAppreciated
    }
    
    public var isSaved: Bool {
        return message.isSaved
    }
    
    public init(dependencies: Dependencies, message: Message, type: MessageType) {
        self.dependencies = dependencies
        self.message = message
        self.type = type
    }
    
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
    
    typealias MessageAppreciateResult = Result<MessageAppreciateResponse, MessageError>
    
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
