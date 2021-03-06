import Foundation

/// A struct for defining the format of a server endpoint
public struct Endpoint {
    /// The path component of the url.
    public let path: String
    
    /// The query items of a url.
    public let queryItems: [URLQueryItem]?
    
    /// A boolean denoting if the endpoint requires authorization.
    public let isAuthorized: Bool
    
    /// A boolean denoting if the endpoint is to an external source.
    public let isExternal: Bool
    
    public init(path: String, queryItems: [URLQueryItem]? = nil, isAuthorized: Bool = true, isExternal: Bool = false) {
        self.path = path
        self.queryItems = queryItems
        self.isAuthorized = isAuthorized
        self.isExternal = isExternal
    }
    
    /// The composition of url components.
    public var url: URL? {
        if isExternal {
            var components = URLComponents(string: path)
            components?.queryItems = queryItems
            
            return components?.url
        } else {
            var components = URLComponents()
            components.scheme = Env.get(.serverScheme)
            components.host = Env.get(.serverHost)
            if let port = Env.get(.serverPort) {
                components.port = Int(port)
            }
            components.path = joinedPath(path)
            components.queryItems = (queryItems ?? []).isEmpty ? .none : queryItems
            
            return components.url
        }
    }
    
    private func joinedPath(_ path: String) -> String {
        guard let apiVersion = Env.get(.apiVersion) else {
            preconditionFailure("Api version needs to be specified.")
        }

        return "/v\(apiVersion)\(path)"
    }
}

// MARK: - Authentication Endpoints

extension Endpoint {

    static var signUp: Endpoint {
        return Endpoint(path: "/auth/signup", isAuthorized: false)
    }
    
    static var signIn: Endpoint {
        return Endpoint(path: "/auth/signin", isAuthorized: false)
    }
    
    static func refresh(token: String) -> Endpoint {
        let queryItems = [URLQueryItem(name: "refresh_token", value: token)]
        
        return Endpoint(path: "/auth/refresh", queryItems: queryItems, isAuthorized: false)
    }
    
    static var passwordResetEmail: Endpoint {
        return Endpoint(path: "/auth/passwordreset/email", queryItems: nil, isAuthorized: false)
    }
    
    static func passwordReset(token: String) -> Endpoint {
        let queryItems = [URLQueryItem(name: "token", value: token)]
        
        return Endpoint(path: "/auth/passwordreset", queryItems: queryItems, isAuthorized: false)
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
    
    static func message(with id: Int) -> Endpoint {
        return Endpoint(path: "/message/\(id)")
    }
    
    static var message: Endpoint {
        return Endpoint(path: "/message")
    }
    
    static func messageAction(with id: Int, type: MessageActionType) -> Endpoint {
        let queryItems = [URLQueryItem(name: "type", value: type.rawValue)]
        
        return Endpoint(path: "/message/\(id)/action", queryItems: queryItems)
    }
    
    static func deleteMessage(with id: Int) -> Endpoint {
        return Endpoint(path: "/message/\(id)")
    }
    
    static func love(for id: Int, start: String?, end: String?) -> Endpoint {
        var queryItems: [URLQueryItem] = []
        
        if let start = start {
            queryItems.append(URLQueryItem(name: "start", value: start))
        }
        
        if let end = end {
            queryItems.append(URLQueryItem(name: "end", value: end))
        }
        
        return Endpoint(path: "/message/\(id)/love", queryItems: queryItems)
    }
    
    static func appreciation(for id: Int, start: String?, end: String?) -> Endpoint {
        var queryItems: [URLQueryItem] = []
        
        if let start = start {
            queryItems.append(URLQueryItem(name: "start", value: start))
        }
        
        if let end = end {
            queryItems.append(URLQueryItem(name: "end", value: end))
        }
        
        return Endpoint(path: "/message/\(id)/appreciation", queryItems: queryItems)
    }
}

// MARK: - User Endpoints

extension Endpoint {
    static var helpfulUsers: Endpoint {
        return Endpoint(path: "/user/helpful")
    }
    
    static func user(filter: String, start: String?, end: String?) -> Endpoint {
        var queryItems: [URLQueryItem] = []
        
        if !filter.isEmpty {
            queryItems.append(URLQueryItem(name: "filter", value: filter))
        }
        
        if let start = start {
            queryItems.append(URLQueryItem(name: "start", value: start))
        }
        
        if let end = end {
            queryItems.append(URLQueryItem(name: "end", value: end))
        }
        
        return Endpoint(path: "/user", queryItems: queryItems)
    }
    
    static func user(username: String) -> Endpoint {
        return Endpoint(path: "/user/\(username)")
    }
    
    static var userAddTokens: Endpoint {
        return Endpoint(path: "/user/tokens")
    }
    
    static var userNotificationDeviceToken: Endpoint {
        return Endpoint(path: "/user/notification/deviceToken")
    }
    
    static var changeEmail: Endpoint {
        return Endpoint(path: "/user/email")
    }
    
    static var changePassword: Endpoint {
        return Endpoint(path: "/user/password")
    }
}

// MARK: - Notification Endpoints

extension Endpoint {
    static func notification(start: String?, end: String?) -> Endpoint {
        var queryItems: [URLQueryItem] = []
        
        if let start = start {
            queryItems.append(URLQueryItem(name: "start", value: start))
        }
        
        if let end = end {
            queryItems.append(URLQueryItem(name: "end", value: end))
        }
        
        return Endpoint(path: "/notification", queryItems: queryItems)
    }
}

// MARK: - External Endpoints

extension Endpoint {
    static var itunesRatingCount: Endpoint {
        return Endpoint(path: "https://itunes.apple.com/ca/lookup", queryItems: [URLQueryItem(name: "id", value: "1474711114")],
                        isAuthorized: false, isExternal: true)
    }
}
