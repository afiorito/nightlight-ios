public class MessageViewModel {
    public typealias Dependencies = StyleManaging
    
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
}
