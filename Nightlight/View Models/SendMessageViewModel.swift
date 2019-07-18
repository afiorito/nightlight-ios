import Foundation

public class SendMessageViewModel {
    public typealias Dependencies = MessageServiced & StyleManaging
    
    private let dependencies: Dependencies
    
    public var theme: Theme {
        return dependencies.styleManager.theme
    }
    
    public init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    public func sendMessage(title: String?, body: String?, numPeople: String?, isAnonymous: Bool, result: @escaping (Result<MessageViewModel, MessageError>) -> Void) {
        guard let title = title, !title.isEmpty else {
            return result(.failure(.invalidTitle))
        }
        
        guard let body = body, !body.isEmpty else {
            return result(.failure(.invalidBody))
        }
        
        guard let numPeopleString = numPeople, let numPeople = Int(numPeopleString) else {
            return result(.failure(.invalidNumPeople))
        }
        
        let message = NewMessageData(title: title, body: body, numPeople: numPeople, isAnonymous: isAnonymous)
        dependencies.messageService.sendMessage(message) { messageResult in
            switch messageResult {
            case .success(let message):
                let viewModel = MessageViewModel(dependencies: self.dependencies, message: message)
                DispatchQueue.main.async { result(.success(viewModel)) }
            case .failure(let error):
                DispatchQueue.main.async { result(.failure(error)) }
            }
            
        }
    }
}
