import Foundation

public protocol MessageServiced {
    var messageService: MessageService { get set }
}

public class MessageService {
    
    private let httpClient: HttpClient
    
    init(httpClient: HttpClient) {
        self.httpClient = httpClient
    }
    
    public func getMessages(type: MessageType, start: String?, end: String?, result: @escaping (Result<MessageResponse, MessageError>) -> Void) {
        httpClient.get(endpoint: Endpoint.message(type: type, start: start, end: end)) { networkResult in
            switch networkResult {
            case .success(_, let data):
                guard let messageResponse: MessageResponse = try? data.decodeJSON() else {
                    return result(.failure(.unknown))
                }
                
                result(.success(messageResponse))
                
            case .failure:
                result(.failure(.unknown))
            }
        }
    }
    
    public func actionMessage<Action: Codable>(with id: Int, type: MessageActionType, result: @escaping (Result<Action, MessageError>) -> Void) {
        httpClient.put(endpoint: Endpoint.messageAction(with: id, type: type), body: nil) { actionResult in
            switch actionResult {
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
