import Foundation

/// A protocol for being able to access standard UserDefaults instance.
public protocol UserDefaultsManaging {
    /// The instance of UserDefaults manager.
    var userDefaultsManager: UserDefaultsManager { get }
}

/// Handles operations around UserDefaults.
public class UserDefaultsManager {
    private let userDefaults: UserDefaults
    
    /**
     Initialize the UserDefaults manager with an instance of UserDefaults.
     
     - parameter userDefaults: The UserDefaults instance used as a backing store.
     */
    public init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }
    
    /// A Boolean value that determines whether the onboarding screen have displayed.
    public var hasOnboarded: Bool {
        get { return userDefaults.bool(forKey: UserDefaultsKey.hasOnboarded.rawValue) }
        set { userDefaults.set(newValue, forKey: UserDefaultsKey.hasOnboarded.rawValue) }
    }
    
    /// The currently selected theme.
    public var theme: Theme {
        get {
            if let theme = Theme(rawValue: userDefaults.string(forKey: UserDefaultsKey.theme.rawValue) ?? "") {
                return theme
            }
            
            if #available(iOS 13, *) {
                return .system
            } else {
                return .light
            }
            
        }
        set {
            userDefaults.set(newValue.rawValue, forKey: UserDefaultsKey.theme.rawValue)
        }
    }
    
    /// The currently selected message default.
    public var messageDefault: MessageDefault {
        get {
            return MessageDefault(rawValue: userDefaults.string(forKey: UserDefaultsKey.messageDefault.rawValue) ?? "") ?? .username
        }
        
        set {
            userDefaults.set(newValue.rawValue, forKey: UserDefaultsKey.messageDefault.rawValue)
        }
    }
    
    /// The device token for notifications.
    public var deviceToken: String? {
        get {
            return userDefaults.string(forKey: UserDefaultsKey.deviceToken.rawValue)
        }
        
        set {
            userDefaults.set(newValue, forKey: UserDefaultsKey.deviceToken.rawValue)
        }
    }
}
