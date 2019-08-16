import Foundation

/// A view model for handling a sending appreciation.
public class SendAppreciationViewModel {
    public typealias Dependencies = KeychainManaging & MessageServiced & StyleManaging

    /// The required dependencies.
    private let dependencies: Dependencies
    
    /// The backing message model.
    private var message: Message
    
    /// The number of tokens a person has.
    var tokens: Int {
        let tokens = try? dependencies.keychainManager.integer(forKey: KeychainKey.tokens.rawValue)

        return tokens ?? 0
    }
    
    init(dependencies: Dependencies, message: Message) {
        self.dependencies = dependencies
        self.message = message
    }
    
    /**
     Appreciate a message.
     
     - parameter result: the result of appreciating a message.
     */
    public func appreciateMessage(result: @escaping (Result<Bool, Error>) -> Void) {
        dependencies.messageService.actionMessage(with: message.id, type: .appreciate) { (appreciateResult: Result<MessageAppreciateResponse, MessageError>) in
            switch appreciateResult {
            case .success(let appreciateResponse):
                self.message.isAppreciated = appreciateResponse.isAppreciated
                result(.success(appreciateResponse.isAppreciated))
            case .failure(let error):
                result(.failure(error))
            }
        }
    }
}
