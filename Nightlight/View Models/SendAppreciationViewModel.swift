import Foundation

public class SendAppreciationViewModel {
    public typealias Dependencies = KeychainManaging & MessageServiced & StyleManaging
    
    var numTokens: Int {
        let numTokens = try? dependencies.keychainManager.integer(forKey: KeychainKey.numTokens.rawValue)
        
        return numTokens ?? 0
    }
    
    private let dependencies: Dependencies
    private var message: Message
    
    init(dependencies: Dependencies, message: Message) {
        self.dependencies = dependencies
        self.message = message
    }
    
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
