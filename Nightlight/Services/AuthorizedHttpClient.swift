import Foundation

public class AuthorizedHttpClient: HttpClient {
    
    private let keychainManager: KeychainManager
    
    private var isReauthenticating: Bool = false
    
    private var pendingRequests = [(urlRequest: URLRequest, result: (HttpClient.RequestResult) -> Void)]()
    
    public init(urlSession: URLSession = .shared, keychainManager: KeychainManager) {
        self.keychainManager = keychainManager
        
        super.init(urlSession: urlSession)
    }
    
    @discardableResult
    public override func request(urlRequest: URLRequest, result: @escaping (HttpClient.RequestResult) -> Void) -> URLSessionDataTask? {
        guard let accessToken = try? keychainManager.string(forKey: KeychainKey.accessToken.rawValue) else {
            self.notifyUnauthorized()
            return nil
        }

        var injectedRequest = urlRequest
        injectedRequest.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        let task = super.request(urlRequest: injectedRequest) { [weak self] networkResult in
            guard let self = self else { return }

            switch networkResult {
            case .success:
                result(networkResult)
            case .failure(let error):
                guard let httpError = error as? HttpError, case .unauthorized = httpError else {
                    return result(networkResult)
                }

                // temporarily store the callbacks to remake requests once authenticated.
                self.pendingRequests.append((urlRequest: urlRequest, result: result))

                if !self.isReauthenticating {
                    self.reauthorize { [unowned self] result in
                        switch result {
                        case .success:
                            self.isReauthenticating = false
                            
                            // remake all requests that were authorized while reauthenticating.
                            for pendingRequest in self.pendingRequests.reversed() {
                                self.request(urlRequest: pendingRequest.urlRequest, result: pendingRequest.result)
                            }
                            self.pendingRequests.removeAll()
                            
                        case .failure:
                            self.notifyUnauthorized()
                        }
                    }
                }
            }
        }
        
        return task
    }
    
    private func reauthorize(result: @escaping (HttpClient.RequestResult) -> Void) {
        isReauthenticating = true

        guard let refreshToken = try? keychainManager.string(forKey: KeychainKey.refreshToken.rawValue),
            let url = Endpoint.refresh(token: refreshToken).url
        else {
            return notifyUnauthorized()
        }
        
        super.request(urlRequest: URLRequest(url: url)) { [weak self] refreshResult in
            switch refreshResult {
            case .success(_, let data):
                guard let authResponse: AuthResponse = try? data.decodeJSON() else {
                    return result(.failure(AuthError.unknown))
                }
                
                do {
                    try self?.keychainManager.set(authResponse.token.access, forKey: KeychainKey.accessToken.rawValue)
                    try self?.keychainManager.set(authResponse.token.refresh, forKey: KeychainKey.refreshToken.rawValue)
                } catch {
                    return result(.failure(AuthError.unknown))
                }
                
                result(refreshResult)
                
            case .failure:
                result(refreshResult)
                
            }
        }
    }
    
    private func notifyUnauthorized() {
        isReauthenticating = false
        pendingRequests.removeAll()
        NLNotification.unauthorized.post()
    }
}
