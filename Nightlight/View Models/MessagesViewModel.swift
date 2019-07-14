import Foundation

public class MessagesViewModel {
    
    public typealias Dependencies = MessageServiced & StyleManaging
    
    private let dependencies: Dependencies
    
    public var theme: Theme {
        return dependencies.styleManager.theme
    }
    
    private let type: MessageType
    
    private var startPage: String?
    private var endPage: String?
    
    private(set) var totalCount: Int = 0
    
    private var isFetchInProgress = false
    
    public init(dependencies: Dependencies, type: MessageType) {
        self.dependencies = dependencies
        self.type = type
    }
    
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
                
                DispatchQueue.main.async {
                    let messages = messageResponse.data.map { MessageViewModel(dependencies: self.dependencies, message: $0) }
                    result(.success(messages))
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    result(.failure(error))
                }
            }
        }
    }
 
    public func resetPaging() {
        startPage = nil
        endPage = nil
    }
    
}
