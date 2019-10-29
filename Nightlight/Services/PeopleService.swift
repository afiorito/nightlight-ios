import Foundation

public protocol PeopleServiced {
    var peopleService: PeopleService { get }
}

/// A service for handling people.
public class PeopleService {
    private let httpClient: HttpClient
    private let keychainManager: KeychainManager
    
    /// The active task for filtering users.
    private var filterTask: URLSessionDataTask?
    
    public init(httpClient: HttpClient, keychainManager: KeychainManager) {
        self.httpClient = httpClient
        self.keychainManager = keychainManager
    }
    
    /**
     Retrieve helpful people.
     
     - parameter result: the result of retrieving helpful people.
     */
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
    
    /**
     Retrieve people.
     
     - parameter endpoint: The endpoint to retrieve people.
     - parameter result: The result of retrieving people.
     */
    public func getPeople(endpoint: Endpoint, result: @escaping (Result<PaginatedResponse<User>, PersonError>) -> Void) {
        if let task = filterTask {
            task.cancel()
        }
        
        filterTask = httpClient.get(endpoint: endpoint, result: { [weak self] networkResult in
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
    
    /**
     Retrieve a person.

     - parameter result: the result of retrieving a person.
     */
    public func getPerson(result: ((Result<User, PersonError>) -> Void)? = nil) {
        guard let accessToken = try? keychainManager.string(for: KeychainKey.accessToken.rawValue),
            let jwt = try? JWTDecoder().decode(accessToken),
            let username = jwt["username"] as? String
            else {
                result?(.failure(.unknown))
                return
            }
        
        httpClient.get(endpoint: Endpoint.user(username: username)) { [weak self] networkResult in
            switch networkResult {
            case .success(_, let data):
                guard let person: User = try? data.decodeJSON() else {
                    result?(.failure(.unknown))
                    return
                }
                
                try? self?.keychainManager.set(person.tokens, forKey: KeychainKey.tokens.rawValue)
                try? self?.keychainManager.set(person.username, forKey: KeychainKey.username.rawValue)
                try? self?.keychainManager.set(person.createdAt.timeIntervalSince1970, forKey: KeychainKey.userCreatedAt.rawValue)
                try? self?.keychainManager.set(person.totalLove, forKey: KeychainKey.totalLove.rawValue)
                try? self?.keychainManager.set(person.totalAppreciation, forKey: KeychainKey.totalAppreciation.rawValue)
                
                if let email = person.email {
                    try? self?.keychainManager.set(email, forKey: KeychainKey.email.rawValue)
                }
                
                result?(.success(person))
                
            case .failure:
                result?(.failure(.unknown))
            }
        }
    }
    
    /**
     Add tokens for a user.

     - parameter tokens: the number of tokens to add.
     - parameter result: the result of adding tokens to a user.
     */
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
    
    /**
     Update a user's device token.

     - parameter deviceToken: the new device token of the user.
     - parameter result: the result of updating the device token.
     */
    public func updateDeviceToken(_ deviceToken: String, result: @escaping (Result<Bool, PersonError>) -> Void) {
        let body = try? Data.encodeJSON(value: UserDeviceTokenBody(deviceToken: deviceToken))
        
        httpClient.put(endpoint: Endpoint.userNotificationDeviceToken, body: body) { (networkResult) in
            switch networkResult {
            case .success: result(.success(true))
            case .failure: result(.failure(.unknown))
            }
        }
    }
    
    /**
     Change a user's email.

     - parameter email: the new email of the user.
     - parameter result: the result of changing the email.
     */
    public func changeEmail(_ email: String, result: @escaping (Result<Bool, PersonError>) -> Void) {
        let body = try? Data.encodeJSON(value: EmailBody(email: email))
        
        httpClient.put(endpoint: Endpoint.changeEmail, body: body) { [weak self] networkResult in
            switch networkResult {
            case .success:
                try? self?.keychainManager.set(email, forKey: KeychainKey.email.rawValue)
                result(.success(true))
            case .failure(let error):
                switch error {
                case HttpError.badRequest(let data):
                    guard let errorDescription: ValidationErrorDescription = try? data.decodeJSON() else {
                        return result(.failure(.unknown))
                    }
                    
                    result(.failure(.validation(errorDescription.reason)))
                default:
                    result(.failure(.unknown))
                }
                
            }
        }
    }
    
    /**
     Change a user's password.

     - parameter email: the new email of the user.
     - parameter result: the result of changing the email.
     */
    public func changePassword(_ password: String, newPassword: String, result: @escaping (Result<Bool, PersonError>) -> Void) {
        let body = try? Data.encodeJSON(value: ChangePasswordBody(oldPassword: password, newPassword: newPassword))
        
        httpClient.put(endpoint: Endpoint.changePassword, body: body) { [weak self] networkResult in
            switch networkResult {
            case .success:
                guard let accessToken = try? self?.keychainManager.string(for: KeychainKey.accessToken.rawValue),
                let jwt = try? JWTDecoder().decode(accessToken),
                let username = jwt["username"] as? String
                else {
                    result(.failure(.unknown))
                    return
                }

                self?.updateWebCredential(username: username, password: newPassword)
                result(.success(true))
            case .failure(let error):
                switch error {
                case HttpError.badRequest(let data):
                    guard let errorDescription: ValidationErrorDescription = try? data.decodeJSON() else {
                        return result(.failure(.unknown))
                    }
                    
                    result(.failure(.validation(errorDescription.reason)))
                default:
                    result(.failure(.unknown))
                }
                
            }
        }
    }
    
    private func updateWebCredential(username: String, password: String) {
        SecAddSharedWebCredential("nightlight.co" as CFString, username as CFString, password as CFString) { _ in }
    }

}
