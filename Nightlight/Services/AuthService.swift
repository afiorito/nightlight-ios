import Foundation

public protocol AuthServiced {
    var authService: AuthService { get set }
}

public class AuthService {
    
    private let httpClient: HttpClient
    private let keychainManager: KeychainManager
    
    init(httpClient: HttpClient, keychainManager: KeychainManager) {
        self.httpClient = httpClient
        self.keychainManager = keychainManager
    }
    
    public func signUp(with credentials: SignUpCredentials, result: @escaping (Result<Bool, AuthError>) -> Void) {
        authenticate(endpoint: Endpoint.signUp, body: try? Data.encodeJSON(value: credentials), result: result)
    }
    
    public func signIn(with credentials: SignInCredentials, result: @escaping (Result<Bool, AuthError>) -> Void) {
        authenticate(endpoint: Endpoint.signIn, body: try? Data.encodeJSON(value: credentials), result: result)
    }
    
    private func authenticate(endpoint: Endpoint, body: Data?, result: @escaping (Result<Bool, AuthError>) -> Void) {
        httpClient.post(endpoint: endpoint, body: body) { networkResult in
            switch networkResult {
            case .success(_, let data):
                guard let authResponse: AuthResponse = try? data.decodeJSON() else {
                    return result(.failure(AuthError.unknown))
                }
                
                do {
                    try self.keychainManager.set(authResponse.token.access, forKey: KeychainKey.accessToken.rawValue)
                    try self.keychainManager.set(authResponse.token.refresh, forKey: KeychainKey.refreshToken.rawValue)
                } catch {
                    return result(.failure(.unknown))
                }
                
                result(.success(true))
                
            case .failure(let error):
                switch error {
                case HttpError.badRequest(let data):
                    guard let errorDescription: ValidationErrorDescription = try? data.decodeJSON() else {
                        return result(.failure(.unknown))
                    }
                    
                    result(.failure(AuthError.validation(errorDescription.reason)))
                    
                default:
                    result(.failure(.unknown))
                }
            }
        }
    }
}
