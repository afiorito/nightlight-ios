import Foundation

/// A struct for defining the format of a server endpoint
public struct Endpoint {
    /// The path component of the url.
    let path: String
    
    /// The query items of a url.
    let queryItems: [URLQueryItem]?
    
    let isAuthorized: Bool
    
    init(path: String, queryItems: [URLQueryItem]?, isAuthorized: Bool = true) {
        self.path = path
        self.queryItems = queryItems
        self.isAuthorized = isAuthorized
    }
    
    /// The composition of url components.
    var url: URL? {
        var components = URLComponents()
        components.scheme = Env.get(.serverScheme)
        components.host = Env.get(.serverHost)
        if let port = Env.get(.serverPort) {
            components.port = Int(port)
        }
        components.path = joinedPath(path)
        components.queryItems = queryItems
        
        return components.url
    }
    
    private func joinedPath(_ path: String) -> String {
        guard let apiVersion = Env.get(.apiVersion) else {
            preconditionFailure("Api version needs to be specified.")
        }

        let prefix = "/api/v\(apiVersion)"
        return "\(isAuthorized ? prefix : "")\(path)"
    }
}

// MARK: - Authentication Endpoints

extension Endpoint {
    /// An endpoint for signing up a user
    static var signUp: Endpoint {
        return Endpoint(path: "/signup", queryItems: .none, isAuthorized: false)
    }
    
    /// An endpoint for signing in a user
    static var signIn: Endpoint {
        return Endpoint(path: "/signin", queryItems: .none, isAuthorized: false)
    }
    
    static func refresh(token: String) -> Endpoint {
        let queryItems = [URLQueryItem(name: "refresh_token", value: token)]
        
        return Endpoint(path: "/refresh", queryItems: queryItems, isAuthorized: false)
    }
}

// MARK: - Message Endpoints

extension Endpoint {
    static func message(type: MessageType, start: String?, end: String?) -> Endpoint {
        var queryItems = [URLQueryItem(name: "type", value: type.rawValue)]
        
        if let start = start {
            queryItems.append(URLQueryItem(name: "start", value: start))
        }
        
        if let end = end {
            queryItems.append(URLQueryItem(name: "end", value: end))
        }
        
        return Endpoint(path: "/message", queryItems: queryItems)
    }
}
