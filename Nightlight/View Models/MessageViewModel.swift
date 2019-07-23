import Foundation

public class MessageViewModel {
    public typealias Dependencies = MessageServiced
    
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
    
    public func loveMessage(result: @escaping (Result<MessageViewModel, MessageError>) -> Void) {
        dependencies.messageService.actionMessage(with: message.id, type: .love) { (loveResult: Result<MessageLoveResponse, MessageError>) in
            switch loveResult {
            case .success(let loveResponse):
                
                self.message.isLoved = loveResponse.isLoved
                self.message.loveCount += loveResponse.isLoved ? 1 : -1
                
                DispatchQueue.main.async {
                    result(.success(MessageViewModel(dependencies: self.dependencies, message: self.message, type: self.type)))
                    
                }
                
            case .failure:
                DispatchQueue.main.async { result(.failure(.unknown)) }
            }
        }
    }
    
    public func saveMessage(result: @escaping (Result<MessageViewModel, MessageError>) -> Void) {
        dependencies.messageService.actionMessage(with: message.id, type: .save) { (saveResult: Result<MessageSaveResponse, MessageError>) in
            switch saveResult {
            case .success(let saveResponse):
                
                self.message.isSaved = saveResponse.isSaved

                DispatchQueue.main.async {
                    result(.success(MessageViewModel(dependencies: self.dependencies, message: self.message, type: self.type)))
                }
                
            case .failure:
                DispatchQueue.main.async { result(.failure(.unknown)) }
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
