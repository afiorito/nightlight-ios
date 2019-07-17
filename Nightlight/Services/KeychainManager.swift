import Foundation

/// A protocol for being able to access Keychain.
public protocol KeychainManaging {
    /// The instance of Keychain manager.
    var keychainManager: KeychainManager { get }
}

/// Handles operations around Keychain
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
    
    public func hasValue(forKey key: String, withAccessibility accessibility: KeychainAccessibility? = nil) -> Bool {
        do {
            _ = try data(forKey: key, withAccessibility: accessibility)
            
            return true
        } catch {
            return false
        }
    }
    
    public func integer(forKey key: String, withAccessibility accessibility: KeychainAccessibility? = nil) throws -> Int {
        guard let number = try object(forKey: key, withAccessibility: accessibility) as? NSNumber else {
            throw KeyChainError.unexpectedData
        }
        
        return number.intValue
    }
    
    public func float(forKey key: String, withAccessibility accessibility: KeychainAccessibility? = nil) throws -> Float {
        guard let number = try object(forKey: key, withAccessibility: accessibility) as? NSNumber else {
            throw KeyChainError.unexpectedData
        }
        
        return number.floatValue
    }
    
    public func double(forKey key: String, withAccessibility accessibility: KeychainAccessibility? = nil) throws -> Double {
        guard let number = try object(forKey: key, withAccessibility: accessibility) as? NSNumber else {
            throw KeyChainError.unexpectedData
        }
        
        return number.doubleValue
    }
    
    public func bool(forKey key: String, withAccessibility accessibility: KeychainAccessibility? = nil) throws -> Bool {
        guard let number = try object(forKey: key, withAccessibility: accessibility) as? NSNumber else {
            throw KeyChainError.unexpectedData
        }
        
        return number.boolValue
    }
    
    public func string(forKey key: String, withAccessibility accessibility: KeychainAccessibility? = nil) throws -> String {
        let keychainData = try data(forKey: key, withAccessibility: accessibility)
        
        guard let string = String(data: keychainData, encoding: .utf8) else {
            throw KeyChainError.unexpectedData
        }
        
        return string
    }
    
    public func object(forKey key: String, withAccessibility accessibility: KeychainAccessibility? = nil) throws -> NSCoding {
        let keychainData = try data(forKey: key, withAccessibility: accessibility)
        
        guard let object = NSKeyedUnarchiver.unarchiveObject(with: keychainData) as? NSCoding else {
            throw KeyChainError.unexpectedData
        }
        
        return object
    }
    
    public func data(forKey key: String, withAccessibility accessibility: KeychainAccessibility? = nil) throws -> Data {
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
    
    public func set(_ value: Int, forKey key: String, withAccessibility accessibility: KeychainAccessibility? = nil) throws {
        return try set(NSNumber(value: value), forKey: key, withAccessibility: accessibility)
    }
    
    public func set(_ value: Float, forKey key: String, withAccessibility accessibility: KeychainAccessibility? = nil) throws {
        return try set(NSNumber(value: value), forKey: key, withAccessibility: accessibility)
    }
    
    public func set(_ value: Double, forKey key: String, withAccessibility accessibility: KeychainAccessibility? = nil) throws {
        return try set(NSNumber(value: value), forKey: key, withAccessibility: accessibility)
    }
    
    public func set(_ value: Bool, forKey key: String, withAccessibility accessibility: KeychainAccessibility? = nil) throws {
        return try set(NSNumber(value: value), forKey: key, withAccessibility: accessibility)
    }
    
    public func set(_ value: String, forKey key: String, withAccessibility accessibility: KeychainAccessibility? = nil) throws {
        if let data = value.data(using: .utf8) {
            return try set(data, forKey: key, withAccessibility: accessibility)
        }
        
        throw KeyChainError.unexpectedData
    }
    
    public func set(_ value: NSCoding, forKey key: String, withAccessibility accessibility: KeychainAccessibility? = nil) throws {
        let data = NSKeyedArchiver.archivedData(withRootObject: value)
        
        return try set(data, forKey: key, withAccessibility: accessibility)
    }
    
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
    
    private func update(_ value: Data, forKey key: String, withAccessibility accessibility: KeychainAccessibility? = nil) throws {
        let query = keychainQuery(forKey: key, withAccessibility: accessibility)
        let update = [kSecValueData as String: value]
        
        let status = SecItemUpdate(query as CFDictionary, update as CFDictionary)
        
        if status != errSecSuccess {
            throw KeyChainError.unhandledError(status: status)
        }
    }
    
    public func remove(key: String, withAccessibility accessibility: KeychainAccessibility? = nil) throws {
        let query = keychainQuery(forKey: key, withAccessibility: accessibility)
        
        let status = SecItemDelete(query as CFDictionary)
        
        if status == errSecItemNotFound {
            throw KeyChainError.noKey
        } else if status == errSecSuccess {
            throw KeyChainError.unhandledError(status: status)
        }
    }
    
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
