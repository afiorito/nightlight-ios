import Foundation

/// A view model for handling sending a message.
public class SendMessageViewModel {
    public typealias Dependencies = MessageServiced & UserDefaultsManaging & StyleManaging
    
    /// The required dependencies.
    private let dependencies: Dependencies
    
    /// The active theme.
    public var theme: Theme {
        return dependencies.styleManager.theme
    }
    
    /// A boolean denoting the default state for sending a message anonymously.
    public var isAnonymous: Bool {
        return dependencies.userDefaultsManager.messageDefault == .anonymous
    }
    
    public init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    /**
     Send a message.
     
     - parameter title: the title of a message.
     - parameter body: the body of the message.
     - parameter numPeople: the number of people to send the message to.
     - parameter isAnonymous: a value representing if the message is sent anonymously
     */
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
                let viewModel = MessageViewModel(dependencies: self.dependencies as! MessageViewModel.Dependencies, message: message, type: .sent)
                DispatchQueue.main.async { result(.success(viewModel)) }
            case .failure(let error):
                DispatchQueue.main.async { result(.failure(error)) }
            }
            
        }
    }
}
