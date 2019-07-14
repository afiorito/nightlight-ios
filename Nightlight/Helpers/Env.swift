import Foundation

/// A struct for reading keys from environment xcconfig files
public struct Env {
    
    /// A value that represents the keys of info plist file
    public enum PlistKey: String {
        case serverHost = "server_host"
        case serverScheme = "server_scheme"
        case serverPort = "server_port"
        case apiVersion = "api_version"
    }
    
    /**
     Retrieves a key from the info plist file
     
     - parameter key: The key of the property in the info plist file
     */
    public static func get(_ key: PlistKey) -> String? {
        guard let info = Bundle.main.infoDictionary else {
            preconditionFailure("Info plist file not found.")
        }

        return info[key.rawValue] as? String
    }
}
