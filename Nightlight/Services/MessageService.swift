import Foundation

public protocol MessageServiced {
    var messageService: MessageService { get }
}

/// A service for handling messages.
public class MessageService {
    private let httpClient: HttpClient
    
    init(httpClient: HttpClient) {
        self.httpClient = httpClient
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
     
     - parameter id: the id of the message to perform an action on.
     - parameter type: the type of action to perform on the message.
     - parameter result: the result of performing the action on the message.
     */
    public func actionMessage<Action: Codable>(with id: Int, type: MessageActionType, result: @escaping (Result<Action, MessageError>) -> Void) {
        httpClient.put(endpoint: Endpoint.messageAction(with: id, type: type), body: nil) { networkResult in
            switch networkResult {
            case .success(_, let data):
                guard let actionResponse: Action = try? data.decodeJSON() else {
                    return result(.failure(.unknown))
                }
                
                result(.success(actionResponse))
                
            case .failure(let error):
                if type == .appreciate, case HttpError.badRequest = error {
                    guard let errorBody: SimpleErrorBody = (try? (error as? HttpError)?.data?.decodeJSON()) else {
                        return result(.failure(.unknown))
                    }
                    
                    if errorBody.message == "Invalid Action" {
                        return result(.failure(.alreadyAppreciated))
                    } else {
                        return result(.failure(.insufficientTokens))
                    }
                }
                
                result(.failure(.unknown))
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
}
