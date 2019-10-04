import Foundation

public protocol MessageServiced {
    var messageService: MessageService { get }
}

/// A service for handling messages.
public class MessageService {
    private let httpClient: HttpClient
    private let keychainManager: KeychainManager
    
    public init(httpClient: HttpClient, keychainManager: KeychainManager) {
        self.httpClient = httpClient
        self.keychainManager = keychainManager
    }
    
    /**
     Retrieve messages.
     
     - parameter type: the type of message to retrieve.
     - parameter start: the starting cursor of the message request.
     - parameter end: the ending cursor of the message request.
     - parameter result: the result of retrieving messages.
     */
    public func getMessages(type: MessageType, start: String?, end: String?, result: @escaping (Result<PaginatedResponse<Message>, MessageError>) -> Void) {
        httpClient.get(endpoint: Endpoint.message(type: type, start: start, end: end)) { networkResult in
            switch networkResult {
            case .success(_, let data):
                guard let messageResponse: PaginatedResponse<Message> = try? data.decodeJSON() else {
                    return result(.failure(.unknown))
                }
                
                result(.success(messageResponse))
                
            case .failure:
                result(.failure(.unknown))
            }
        }
    }
    
    /**
     Retrieve a message with a specified id.
     
     - parameter id: the unique id of the message to retrieve.
     - parameter result: the result of retrieving the message.
     */
    public func getMessage(with id: Int, result: @escaping (Result<Message, MessageError>) -> Void) {
        httpClient.get(endpoint: Endpoint.message(with: id)) { networkResult in
            switch networkResult {
            case .success(_, let data):
                guard let messageResponse: Message = try? data.decodeJSON() else {
                    return result(.failure(.unknown))
                }
                
                result(.success(messageResponse))
                
            case .failure(let error):
                switch error {
                case HttpError.badRequest:
                    result(.failure(MessageError.notFound))
                default:
                    result(.failure(.unknown))
                }
            }
        }
    }
    
    /**
     Send a message
     
     - parameter message: the message data used to send a message.
     - parameter result: the result of sending a message.
     */
    public func sendMessage(_ message: NewMessageData, result: @escaping (Result<Message, MessageError>) -> Void) {
        httpClient.post(endpoint: Endpoint.message, body: try? Data.encodeJSON(value: message)) { networkResult in
            switch networkResult {
            case .success(_, let data):
                guard let message: Message = try? data.decodeJSON() else {
                    return result(.failure(.unknown))
                }
                
                result(.success(message))
            case .failure(let error):
                switch error {
                case HttpError.badRequest(let data):
                    guard let errorDescription: ValidationErrorDescription = try? data.decodeJSON() else {
                        return result(.failure(.unknown))
                    }
                    
                    result(.failure(MessageError.validation(errorDescription.reason)))
                    
                default:
                    result(.failure(.unknown))
                }
            }
        }
    }
    
    /**
     Perform an action on a message.
     
     - parameter type: The type of action to perform on the message.
     - parameter message: The message to perform the action on.
     - parameter result: The result of performing the action on the message.
     */
    public func performAction<Action: Codable>(_ type: MessageActionType, for message: Message, result: @escaping (Result<Action, Error>) -> Void) {
        httpClient.put(endpoint: Endpoint.messageAction(with: message.id, type: type), body: nil) { networkResult in
            switch networkResult {
            case .success(_, let data):
                guard let actionResponse: Action = try? data.decodeJSON() else {
                    return result(.failure(HttpError.unknown))
                }
                
                result(.success(actionResponse))
                
            case .failure(let error):
                result(.failure(error))
            }
        }
    }
    
    /**
     Love a message.

     - parameter message: The message to love.
     - parameter result: The result of loving message.
     */
    public func love(message: Message, result: @escaping (Result<Message, MessageError>) -> Void) {
        performAction(.love, for: message) { (networkResult: Result<MessageLoveResponse, Error>) in
            switch networkResult {
            case .success(let loveResponse):
                var updatedMessage = message
                updatedMessage.isLoved = loveResponse.isLoved
                updatedMessage.loveCount = max(0, updatedMessage.loveCount + (loveResponse.isLoved ? 1 : -1))
                result(.success(updatedMessage))
            case .failure:
                result(.failure(.failedAction(.love)))
            }
        }
    }
    
    /**
     Love a message.

     - parameter message: The message to love.
     - parameter result: The result of loving message.
     */
    public func appreciate(message: Message, result: @escaping (Result<Message, MessageError>) -> Void) {
        performAction(.appreciate, for: message) { [weak self] (networkResult: Result<MessageAppreciateResponse, Error>) in
            guard let self = self else { return }
            switch networkResult {
            case .success(let appreciateResponse):
                var updatedMessage = message
                updatedMessage.isAppreciated = appreciateResponse.isAppreciated
                updatedMessage.appreciationCount += 1

                let tokens = (try? self.keychainManager.integer(for: KeychainKey.tokens.rawValue)) ?? 0
                try? self.keychainManager.set(tokens - 100, forKey: KeychainKey.tokens.rawValue)
                
                result(.success(updatedMessage))
            case .failure(let error):
                if case HttpError.badRequest = error {
                    guard let errorBody: SimpleErrorBody = (try? (error as? HttpError)?.data?.decodeJSON()) else {
                        return result(.failure(.failedAction(.appreciate)))
                    }
                    
                    if errorBody.message == "Invalid Action" {
                        return result(.failure(.alreadyAppreciated))
                    } else {
                        return result(.failure(.insufficientTokens))
                    }
                }
                
                result(.failure(.failedAction(.appreciate)))
            }
        }
    }
    
    /**
     Save a message.

     - parameter message: The message to save.
     - parameter result: The result of saving message.
     */
    public func save(message: Message, result: @escaping (Result<Message, MessageError>) -> Void) {
        performAction(.save, for: message) { (networkResult: Result<MessageSaveResponse, Error>) in
            switch networkResult {
            case .success(let saveResponse):
                var updatedMessage = message
                updatedMessage.isSaved = saveResponse.isSaved
                result(.success(updatedMessage))
            case .failure:
                result(.failure(.failedAction(.save)))
            }
        }
    }
    
    /**
     Delete a message
     
     - parameter id: the id of the message to delete.
     - parameter result: the result of deleting the message.
     */
    public func deleteMessage(with id: Int, result: @escaping (Result<MessageDeleteResponse, MessageError>) -> Void) {
        httpClient.delete(endpoint: Endpoint.deleteMessage(with: id)) { networkResult in
            switch networkResult {
            case .success(_, let data):
                guard let deleteResponse: MessageDeleteResponse = try? data.decodeJSON() else {
                    return result(.failure(.unknown))
                }
                
                result(.success(deleteResponse))
                
            case .failure:
                result(.failure(.unknown))
            }
            
        }
    }
    
    /**
     Determines if a message can be deleted given a specified type.
     
     - parameter message: The message to test.
     - parameter type: The type of message.
     */
    public func isDeleteable(message: Message, type: MessageType) -> Bool {
        guard type != .saved, let accessToken = try? keychainManager.string(for: KeychainKey.accessToken.rawValue),
            let jwt = try? JWTDecoder().decode(accessToken), let username = jwt["username"] as? String
            else { return false }
        
        return message.user.username == username || type == .received
    }
}
