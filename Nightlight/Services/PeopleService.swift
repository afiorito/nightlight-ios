import Foundation

public protocol PeopleServiced {
    var peopleService: PeopleService { get }
}

public class PeopleService {
    
    private let httpClient: HttpClient
    private let keychainManager: KeychainManager
    
    private var filterTask: URLSessionDataTask?
    
    init(httpClient: HttpClient, keychainManager: KeychainManager) {
        self.httpClient = httpClient
        self.keychainManager = keychainManager
    }
    
    public func getHelpfulPeople(result: @escaping (Result<[User], PersonError>) -> Void) {
        httpClient.get(endpoint: Endpoint.helpfulUsers) { networkResult in
            switch networkResult {
            case .success(_, let data):
                guard let peopleResponse: [User] = try? data.decodeJSON() else {
                    return result(.failure(.unknown))
                }
                
                result(.success(peopleResponse))
                
            case .failure:
                result(.failure(.unknown))
            }
        }
    }
    
    public func getPeople(filter: String, start: String?, end: String?, result: @escaping (Result<PaginatedResponse<User>, PersonError>) -> Void) {
        if let task = filterTask {
            task.cancel()
        }
        
        filterTask = httpClient.get(endpoint: Endpoint.user(filter: filter, start: start, end: end), result: { [weak self] networkResult in
            self?.filterTask = nil

            switch networkResult {
            case .success(_, let data):
                guard let peopleResponse: PaginatedResponse<User> = try? data.decodeJSON() else {
                    return result(.failure(.unknown))
                }
                
                result(.success(peopleResponse))
                
            case .failure:
                result(.failure(.unknown))
            }
        })
    }
    
    public func getPerson(result: @escaping (Result<User, PersonError>) -> Void) {
        guard let accessToken = try? keychainManager.string(forKey: KeychainKey.accessToken.rawValue),
            let jwt = try? JWTDecoder().decode(accessToken),
            let username = jwt["username"] as? String
            else {
                return result(.failure(.unknown))
            }
        
        httpClient.get(endpoint: Endpoint.user(username: username)) { networkResult in
            switch networkResult {
            case .success(_, let data):
                guard let person: User = try? data.decodeJSON() else {
                    return result(.failure(.unknown))
                }
                
                result(.success(person))
                
            case .failure:
                result(.failure(.unknown))
            }
        }
    }
    
    public func addTokens(tokens: Int, result: @escaping (Result<Int, PersonError>) -> Void) {
        guard let receiptURL = Bundle.main.appStoreReceiptURL, let receiptData = try? Data(contentsOf: receiptURL) else {
            return result(.failure(.unknown))
        }
        
        let receiptString = receiptData.base64EncodedString()
        
        let tokensBody = try? Data.encodeJSON(value: UserTokensBody(tokens: tokens, receipt: receiptString))
        
        httpClient.put(endpoint: Endpoint.userAddTokens, body: tokensBody) { networkResult in
            switch networkResult {
            case .success(_, let data):
                guard let tokensBody: UserTokensResponse = try? data.decodeJSON() else {
                    return result(.failure(.unknown))
                }
                
                result(.success(tokensBody.tokens))
            case .failure:
                result(.failure(.unknown))
            }
        }
    }

}
