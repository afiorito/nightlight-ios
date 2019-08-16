import Foundation

/// A protocol for being able to access Keychain.
public protocol KeychainManaging {
    /// The instance of Keychain manager.
    var keychainManager: KeychainManager { get }
}

/// Handles operations around the iOS Keychain.
public class KeychainManager {
    enum KeyChainError: Error {
        case noKey
        case unexpectedData
        case unhandledError(status: OSStatus)
    }
    private let serviceName: String
    private let accessGroup: String?
    
    public init(serviceName: String? = nil, accessGroup: String? = nil) {
        self.serviceName = serviceName ?? Bundle.main.bundleIdentifier ?? "KeychainManager"
        self.accessGroup = accessGroup
    }
    
    /**
     Determines if keychain data exists for a specified key.
     
     - parameter key: the key to check for.
     - parameter accessibility: an optional accessibility to use when retrieving keychain data.
     */
    public func hasValue(for key: String, withAccessibility accessibility: KeychainAccessibility? = nil) -> Bool {
        do {
            _ = try data(for: key, withAccessibility: accessibility)
            
            return true
        } catch {
            return false
        }
    }
    
    // MARK: - Getters
    
    /**
     Retrieves keychain data as an integer for a specified key.
     
     - parameter key: the key to lookup data for.
     - parameter accessibility: an optional accessibility to use when retrieving keychain data.
     */
    public func integer(for key: String, withAccessibility accessibility: KeychainAccessibility? = nil) throws -> Int {
        guard let number = try object(for: key, withAccessibility: accessibility) as? NSNumber else {
            throw KeyChainError.unexpectedData
        }
        
        return number.intValue
    }
    
    /**
     Retrieves keychain data as a float for a specified key.
     
     - parameter key: the key to lookup data for.
     - parameter accessibility: an optional accessibility to use when retrieving keychain data.
     */
    public func float(for key: String, withAccessibility accessibility: KeychainAccessibility? = nil) throws -> Float {
        guard let number = try object(for: key, withAccessibility: accessibility) as? NSNumber else {
            throw KeyChainError.unexpectedData
        }
        
        return number.floatValue
    }
    
    /**
     Retrieves keychain data as a double for a specified key.
     
     - parameter key: the key to lookup data for.
     - parameter accessibility: an optional accessibility to use when retrieving keychain data.
     */
    public func double(for key: String, withAccessibility accessibility: KeychainAccessibility? = nil) throws -> Double {
        guard let number = try object(for: key, withAccessibility: accessibility) as? NSNumber else {
            throw KeyChainError.unexpectedData
        }
        
        return number.doubleValue
    }
    
    /**
     Retrieves keychain data as a boolean for a specified key.
     
     - parameter key: the key to lookup data for.
     - parameter accessibility: an optional accessibility to use when retrieving keychain data.
     */
    public func bool(for key: String, withAccessibility accessibility: KeychainAccessibility? = nil) throws -> Bool {
        guard let number = try object(for: key, withAccessibility: accessibility) as? NSNumber else {
            throw KeyChainError.unexpectedData
        }
        
        return number.boolValue
    }
    
    /**
     Retrieves keychain data as a string for a specified key.
     
     - parameter key: the key to lookup data for.
     - parameter accessibility: an optional accessibility to use when retrieving keychain data.
     */
    public func string(for key: String, withAccessibility accessibility: KeychainAccessibility? = nil) throws -> String {
        let keychainData = try data(for: key, withAccessibility: accessibility)
        
        guard let string = String(data: keychainData, encoding: .utf8) else {
            throw KeyChainError.unexpectedData
        }
        
        return string
    }
    
    /**
     Retrieves keychain data as an NSCoding object for a specified key.
     
     - parameter key: the key to lookup data for.
     - parameter accessibility: an optional accessibility to use when retrieving keychain data.
     */
    public func object(for key: String, withAccessibility accessibility: KeychainAccessibility? = nil) throws -> NSCoding {
        let keychainData = try data(for: key, withAccessibility: accessibility)
        
        guard let object = NSKeyedUnarchiver.unarchiveObject(with: keychainData) as? NSCoding else {
            throw KeyChainError.unexpectedData
        }
        
        return object
    }
    
    /**
     Retrieves keychain data as a Data object for a specified key.
     
     - parameter key: the key to lookup data for.
     - parameter accessibility: an optional accessibility to use when retrieving keychain data.
     */
    public func data(for key: String, withAccessibility accessibility: KeychainAccessibility? = nil) throws -> Data {
        var query = keychainQuery(forKey: key, withAccessibility: accessibility)
        query[kSecMatchLimit as String] = kSecMatchLimitOne
        query[kSecReturnData as String] = kCFBooleanTrue
        
        var result: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        guard status != errSecItemNotFound else { throw KeyChainError.noKey }
        guard status == errSecSuccess else { throw KeyChainError.unhandledError(status: status) }
        
        guard let data = result as? Data else { throw KeyChainError.unexpectedData }
        
        return data
    }
    
    // MARK: - Setters
    
    /**
     Save an integer value to the keychain associated with a specified key.
     
     - parameter value: the value to save.
     - parameter key: the key to save the value under.
     - parameter accessibility: an optional accessibility to use when setting the keychain data.
     */
    public func set(_ value: Int, forKey key: String, withAccessibility accessibility: KeychainAccessibility? = nil) throws {
        return try set(NSNumber(value: value), forKey: key, withAccessibility: accessibility)
    }
    
    /**
     Save a float value to the keychain associated with a specified key.
     
     - parameter value: the value to save.
     - parameter key: the key to save the value under.
     - parameter accessibility: an optional accessibility to use when setting the keychain data.
     */
    public func set(_ value: Float, forKey key: String, withAccessibility accessibility: KeychainAccessibility? = nil) throws {
        return try set(NSNumber(value: value), forKey: key, withAccessibility: accessibility)
    }
    
    /**
     Save a double value to the keychain associated with a specified key.
     
     - parameter value: the value to save.
     - parameter key: the key to save the value under.
     - parameter accessibility: an optional accessibility to use when setting the keychain data.
     */
    public func set(_ value: Double, forKey key: String, withAccessibility accessibility: KeychainAccessibility? = nil) throws {
        return try set(NSNumber(value: value), forKey: key, withAccessibility: accessibility)
    }
    
    /**
     Save a boolean value to the keychain associated with a specified key.
     
     - parameter value: the value to save.
     - parameter key: the key to save the value under.
     - parameter accessibility: an optional accessibility to use when setting the keychain data.
     */
    public func set(_ value: Bool, forKey key: String, withAccessibility accessibility: KeychainAccessibility? = nil) throws {
        return try set(NSNumber(value: value), forKey: key, withAccessibility: accessibility)
    }
    
    /**
     Save a string value to the keychain associated with a specified key.
     
     - parameter value: the value to save.
     - parameter key: the key to save the value under.
     - parameter accessibility: an optional accessibility to use when setting the keychain data.
     */
    public func set(_ value: String, forKey key: String, withAccessibility accessibility: KeychainAccessibility? = nil) throws {
        if let data = value.data(using: .utf8) {
            return try set(data, forKey: key, withAccessibility: accessibility)
        }
        
        throw KeyChainError.unexpectedData
    }
    
    /**
     Save an NSCoding object to the keychain associated with a specified key.
     
     - parameter value: the value to save.
     - parameter key: the key to save the value under.
     - parameter accessibility: an optional accessibility to use when setting the keychain data.
     */
    public func set(_ value: NSCoding, forKey key: String, withAccessibility accessibility: KeychainAccessibility? = nil) throws {
        let data = NSKeyedArchiver.archivedData(withRootObject: value)
        
        return try set(data, forKey: key, withAccessibility: accessibility)
    }
    
    /**
     Save a Data object to the keychain associated with a specified key.
     
     - parameter value: the value to save.
     - parameter key: the key to save the value under.
     - parameter accessibility: an optional accessibility to use when setting the keychain data.
     */
    public func set(_ value: Data, forKey key: String, withAccessibility accessibility: KeychainAccessibility? = nil) throws {
        var query = keychainQuery(forKey: key, withAccessibility: accessibility)
        
        query[kSecValueData as String] = value
        
        if accessibility == nil {
            query[kSecAttrAccessible as String] = KeychainAccessibility.whenUnlocked.keychainAttrValue
        }
        
        let status = SecItemAdd(query as CFDictionary, nil)
        
        if status == errSecDuplicateItem {
            return try update(value, forKey: key, withAccessibility: accessibility)
        } else if status != errSecSuccess {
            throw KeyChainError.unhandledError(status: status)
        }
    }
    
    /**
     Update existing data in the keychain for a specified key.
     
     - parameter value: the value to save.
     - parameter key: the key to save the value under.
     - parameter accessibility: an optional accessibility to use when setting the keychain data.
     */
    private func update(_ value: Data, forKey key: String, withAccessibility accessibility: KeychainAccessibility? = nil) throws {
        let query = keychainQuery(forKey: key, withAccessibility: accessibility)
        let update = [kSecValueData as String: value]
        
        let status = SecItemUpdate(query as CFDictionary, update as CFDictionary)
        
        if status != errSecSuccess {
            throw KeyChainError.unhandledError(status: status)
        }
    }
    
    /**
     Remove keychain data associated with a specified key.
     
     - parameter key: the key to remove data for.
     - parameter accessibility: an optional accessibility to use when retrieving keychain data.
     */
    public func remove(key: String, withAccessibility accessibility: KeychainAccessibility? = nil) throws {
        let query = keychainQuery(forKey: key, withAccessibility: accessibility)
        
        let status = SecItemDelete(query as CFDictionary)
        
        if status == errSecItemNotFound {
            throw KeyChainError.noKey
        } else if status == errSecSuccess {
            throw KeyChainError.unhandledError(status: status)
        }
    }
    
    /**
     Remove all keychain data.
     */
    public func removeAllKeys() throws {
        var query: [String: Any] = [kSecClass as String: kSecClassGenericPassword]
        query[kSecAttrService as String] = serviceName
        
        if let accessGroup = accessGroup {
            query[kSecAttrAccessGroup as String] = accessGroup
        }
        
        let status = SecItemDelete(query as CFDictionary)
        
        if status != errSecSuccess {
            throw KeyChainError.unhandledError(status: status)
        }
    }
    
    /**
     Setup the keychain query dictionary.
     
     - parameter key: The key of the query.
     - parameter accessibility: optional accessibility to use when querying the keychain.
     */
    private func keychainQuery(forKey key: String, withAccessibility accessibility: KeychainAccessibility? = nil) -> [String: Any] {
        var query: [String: Any] = [kSecClass as String: kSecClassGenericPassword]
        query[kSecAttrService as String] = serviceName
        
        if let accessibility = accessibility {
            query[kSecAttrAccessible as String] = accessibility.keychainAttrValue
        }
        
        if let accessGroup = accessGroup {
            query[kSecAttrAccessGroup as String] = accessGroup
        }
        
        query[kSecAttrAccount as String] = key.data(using: .utf8)
        
        return query
    }

}
