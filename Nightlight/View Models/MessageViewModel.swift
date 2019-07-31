import Foundation
import StoreKit

public class MessageViewModel {
    public typealias MessageResultCompletion = (Result<MessageViewModel, MessageError>) -> Void
    public typealias Dependencies = MessageServiced & IAPManaging
    
    private var purchaseCompletionHandler: MessageResultCompletion?
    
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
    
    public func loveMessage(result: @escaping MessageResultCompletion) {
        dependencies.messageService.actionMessage(with: message.id, type: .love) { (loveResult: Result<MessageLoveResponse, MessageError>) in
            switch loveResult {
            case .success(let loveResponse):
                
                self.message.isLoved = loveResponse.isLoved
                self.message.loveCount += loveResponse.isLoved ? 1 : -1
                
                DispatchQueue.main.async {
                    result(.success(self))
                    
                }
                
            case .failure:
                DispatchQueue.main.async { result(.failure(.unknown)) }
            }
        }
    }
    
    public func saveMessage(result: @escaping MessageResultCompletion) {
        dependencies.messageService.actionMessage(with: message.id, type: .save) { (saveResult: Result<MessageSaveResponse, MessageError>) in
            switch saveResult {
            case .success(let saveResponse):
                
                self.message.isSaved = saveResponse.isSaved

                DispatchQueue.main.async {
                    result(.success(self))
                }
                
            case .failure:
                DispatchQueue.main.async { result(.failure(.unknown)) }
            }
        }
    }
    
    public func appreciateMessage(result: @escaping MessageResultCompletion) {
        HttpClient().head(endpoint: Endpoint(path: "/", queryItems: nil, isAuthorized: false)) { (statusResult) in
            switch statusResult {
            case .success:
                self.purchaseCompletionHandler = result
                self.dependencies.iapManager.delegate = self
                self.dependencies.iapManager.purchase(.appreciation)
            case .failure:
                result(.failure(.unknown))
            }
        }
    }
    
    private func appreciateMessage(result: @escaping (Result<Bool, Error>) -> Void) {
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

extension MessageViewModel: IAPManagerDelegate {
    public func iapManager(_ iapManager: IAPManager, didComplete transaction: SKPaymentTransaction) {
        appreciateMessage { [weak self] (result: Result<Bool, Error>) in
            guard let self = self
                else { return }
            
            self.finish(transaction: transaction)
            
            switch result {
            case .success(let isAppreciated):
                print(isAppreciated)
                if isAppreciated {
                    self.purchaseCompletionHandler?(.success(self))
                    return
                }
                self.purchaseCompletionHandler?(.failure(.unknown))
            case .failure:
                print("fail")
                self.purchaseCompletionHandler?(.failure(.unknown))
            }
        }
    }
    
    public func iapManager(_ iapManager: IAPManager, didFail transaction: SKPaymentTransaction) {
        self.finish(transaction: transaction)
        self.purchaseCompletionHandler?(.failure(.unknown))
    }

    private func finish(transaction: SKPaymentTransaction) {
        dependencies.iapManager.paymentQueue.finishTransaction(transaction)
        purchaseCompletionHandler = nil
    }
    
}
