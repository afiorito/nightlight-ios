import Foundation

public protocol MessageServiced {
    var messageService: MessageService { get }
}

public class MessageService {
    
    private let httpClient: HttpClient
    
    init(httpClient: HttpClient) {
        self.httpClient = httpClient
    }
    
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
    
    public func actionMessage<Action: Codable>(with id: Int, type: MessageActionType, result: @escaping (Result<Action, MessageError>) -> Void) {
        httpClient.put(endpoint: Endpoint.messageAction(with: id, type: type), body: nil) { networkResult in
            switch networkResult {
            case .success(_, let data):
                guard let actionResponse: Action = try? data.decodeJSON() else {
                    return result(.failure(.unknown))
                }
                
                result(.success(actionResponse))
                
            case .failure:
                result(.failure(.unknown))
            }
        }
    }
}
