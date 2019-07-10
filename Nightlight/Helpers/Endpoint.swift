import Foundation

/// A struct for defining the format of a server endpoint
public struct Endpoint {
    /// The path component of the url.
    let path: String
    
    /// The query items of a url.
    let queryItems: [URLQueryItem]?
    
    /// The composition of url components.
    var url: URL? {
        var components = URLComponents()
        components.scheme = Env.get(.serverScheme)
        components.host = Env.get(.serverHost)
        if let port = Env.get(.serverPort) {
            components.port = Int(port)
        }
        components.path = path
        components.queryItems = queryItems
        
        return components.url
    }
}

// MARK: - Authentication Endpoints

extension Endpoint {
    /// An endpoint for signing up a user
    static var signUp: Endpoint {
        return Endpoint(path: "/signup", queryItems: nil)
    }
    
    /// An endpoint for signing in a user
    static var signIn: Endpoint {
        return Endpoint(path: "/signin", queryItems: nil)
    }
}
