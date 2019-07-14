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
}
