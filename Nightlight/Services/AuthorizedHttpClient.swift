import Foundation

public class AuthorizedHttpClient: HttpClient {
    
    private let keychainManager: KeychainManager
    
    public init(urlSession: URLSession = .shared, keychainManager: KeychainManager) {
        self.keychainManager = keychainManager
        
        super.init(urlSession: urlSession)
    }
    
    public override func request(urlRequest: URLRequest, result: @escaping (HttpClient.RequestResult) -> Void) -> URLSessionDataTask? {
        guard let accessToken = try? keychainManager.string(forKey: KeychainKey.accessToken.rawValue) else {
            // send unauthorized notification
            return nil
        }
        var injectedRequest = urlRequest
        injectedRequest.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        return super.request(urlRequest: injectedRequest, result: result)
    }
}
