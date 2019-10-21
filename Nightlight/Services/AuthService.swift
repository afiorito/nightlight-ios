import Foundation

public protocol AuthServiced {
    var authService: AuthService { get }
}

/// A service for handling authentication.
public class AuthService {
    private let httpClient: HttpClient
    private let keychainManager: KeychainManager
    
    public init(httpClient: HttpClient, keychainManager: KeychainManager) {
        self.httpClient = httpClient
        self.keychainManager = keychainManager
    }
    
    /**
     Sign up a user.
     
     - parameter credentials: the sign up credentials of a user.
     - parameter result: the result of signing up a user.
     */
    public func signUp(with credentials: SignUpCredentials, result: @escaping (Result<Bool, AuthError>) -> Void) {
        authenticate(endpoint: Endpoint.signUp, body: try? Data.encodeJSON(value: credentials), result: result)
    }
    
    /**
     Sign in a user.
     
     - parameter credentials: the sign in credentials of a user.
     - parameter result: the result of signing in a user.
     */
    public func signIn(with credentials: SignInCredentials, result: @escaping (Result<Bool, AuthError>) -> Void) {
        authenticate(endpoint: Endpoint.signIn, body: try? Data.encodeJSON(value: credentials), result: result)
    }
    
    /**
     Send a reset email to the specified email address.
     
     - parameter email: The destination email of the password reset email.
     - parameter result: The result of sending the reset password email.
     */
    public func sendPasswordResetEmail(to email: String, result: @escaping (Result<Bool, AuthError>) -> Void) {
        let body = try? Data.encodeJSON(value: EmailBody(email: email))

        httpClient.post(endpoint: Endpoint.passwordResetEmail, body: body) { emailResult in
            switch emailResult {
            case .success:
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
    
    /**
     Reset a user's password.
     
     - parameter newPassword: The new password of the user.
     - parameter token: The reset password token.
     - parameter result: The result of resetting the password.
     */
    public func resetPassword(_ newPassword: String, token: String, result: @escaping (Result<Bool, AuthError>) -> Void) {
        let body = try? Data.encodeJSON(value: PasswordBody(password: newPassword))
        
        httpClient.put(endpoint: Endpoint.passwordReset(token: token), body: body) { passwordResult in
            switch passwordResult {
            case .success:
                result(.success(true))
            case .failure(let error):
                switch error {
                case HttpError.badRequest(let data):
                    guard let errorDescription: ValidationErrorDescription = try? data.decodeJSON() else {
                        if let _: SimpleErrorBody = try? data.decodeJSON() {
                            return result(.failure(.invalidResetToken))
                        }

                        return result(.failure(.unknown))
                    }
                    
                    result(.failure(AuthError.validation(errorDescription.reason)))
                    
                default:
                    result(.failure(.unknown))
                }
            }
        }
    }
    
    /**
     Send an authentication request for a user.
     
     - parameter endpoint: the endpoint for authentication.
     - parameter result: the result of the authentication request.
     */
    private func authenticate(endpoint: Endpoint, body: Data?, result: @escaping (Result<Bool, AuthError>) -> Void) {
        httpClient.post(endpoint: endpoint, body: body) { [weak self] networkResult in
            guard let self = self else { return }
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
