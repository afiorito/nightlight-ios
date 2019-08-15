import Foundation

/// A view model for handling messages.
public class MessagesViewModel {
    public typealias Dependencies = MessageServiced & StyleManaging
    
    /// The required dependencies.
    private let dependencies: Dependencies
    
    /// The active theme.
    public var theme: Theme {
        return dependencies.styleManager.theme
    }
    
    /// The type of message to handle.
    public let type: MessageType
    
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
     
     - parameter result: the result of retrieving the messages.
     */
    public func getMessages(result: @escaping (Result<[MessageViewModel], MessageError>) -> Void) {
        guard !isFetchInProgress && (endPage != nil || startPage == nil) else {
            return
        }

        isFetchInProgress = true
        
        dependencies.messageService.getMessages(type: self.type, start: startPage, end: endPage) { [unowned self] messageResult in
            self.isFetchInProgress = false

            switch messageResult {
            case .success(let messageResponse):
                self.startPage = messageResponse.metadata.start
                self.endPage = messageResponse.metadata.end
                self.totalCount = messageResponse.metadata.total
                
                let messages = messageResponse.data.map {
                    MessageViewModel(dependencies: self.dependencies as! MessageViewModel.Dependencies, message: $0, type: self.type)
                }
                
                DispatchQueue.main.async { result(.success(messages)) }
            case .failure(let error):
                DispatchQueue.main.async { result(.failure(error)) }
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
