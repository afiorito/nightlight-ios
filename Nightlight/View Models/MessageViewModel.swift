import Foundation

public class MessageViewModel {
    public typealias Dependencies = StyleManaging & MessageServiced
    
    private let dependencies: Dependencies
    
    private var message: Message
    
    public var title: String {
        return message.title
    }
    
    public var username: String {
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
    
    public var theme: Theme {
        return dependencies.styleManager.theme
    }
    
    public init(dependencies: Dependencies, message: Message) {
        self.dependencies = dependencies
        self.message = message
    }
    
    public func loveMessage(result: @escaping (Result<MessageViewModel, MessageError>) -> Void) {
        dependencies.messageService.actionMessage(with: message.id, type: .love) { (loveResult: Result<MessageLoveResponse, MessageError>) in
            switch loveResult {
            case .success(let loveResponse):
                
                self.message.isLoved = loveResponse.isLoved
                self.message.loveCount += loveResponse.isLoved ? 1 : -1
                
                DispatchQueue.main.async { result(.success(MessageViewModel(dependencies: self.dependencies, message: self.message))) }
                
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

                DispatchQueue.main.async { result(.success(MessageViewModel(dependencies: self.dependencies, message: self.message))) }
                
            case .failure:
                DispatchQueue.main.async { result(.failure(.unknown)) }
            }
        }
    }
}
