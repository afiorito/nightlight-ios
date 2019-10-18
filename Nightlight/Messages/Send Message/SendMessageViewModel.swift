import Foundation

/// A view model for handling sending a message.
public class SendMessageViewModel {
    public typealias Dependencies = MessageServiced & UserDefaultsManaging & StyleManaging
    
    /// The required dependencies.
    private let dependencies: Dependencies
    
    /// The delegate object that handles user interface updates.
    public weak var uiDelegate: SendMessageViewModelUIDelegate?
    
    /// The delegate object that handles navigation events.
    public weak var navigationDelegate: SendMessageNavigationDelegate?
    
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
    public func sendMessage(title: String?, body: String?, numPeople: String?, isAnonymous: Bool) {
        uiDelegate?.didBeginSending()

        guard let title = title?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines), !title.isEmpty else {
            uiDelegate?.didFailToSend(with: .invalidTitle)
            return
        }
        
        guard let body = body?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines), !body.isEmpty else {
            uiDelegate?.didFailToSend(with: .invalidBody)
            return
        }
        
        guard let numPeopleString = numPeople, let numPeople = Int(numPeopleString) else {
            uiDelegate?.didFailToSend(with: .invalidNumPeople)
            return
        }
        
        let message = NewMessageData(title: title, body: body, numPeople: numPeople, isAnonymous: isAnonymous)
        dependencies.messageService.sendMessage(message) { [weak self] messageResult in
            DispatchQueue.main.async { self?.uiDelegate?.didEndSending() }
            
            switch messageResult {
            case .success(let message):
                DispatchQueue.main.async { self?.navigationDelegate?.didSend(message: message) }
            case .failure(let error):
                DispatchQueue.main.async { self?.uiDelegate?.didFailToSend(with: error) }
            }
            
        }
    }
    
    /**
     Stop sending the message.
     */
    func finish() {
        navigationDelegate?.didFinishSendingMessage()
    }
}
