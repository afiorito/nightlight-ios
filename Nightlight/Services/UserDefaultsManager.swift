import Foundation

/// A protocol for being able to access standard UserDefaults instance.
public protocol UserDefaultsManaging {
    /// The instance of UserDefaults manager.
    var userDefaultsManager: UserDefaultsManager { get }
}

/// Handles operations around UserDefaults
public class UserDefaultsManager {
    
    private enum Key: String {
        case hasOnboarded
    }
    
    private let userDefaults: UserDefaults
    
    /**
     Initialize the UserDefaults manager with an instance of UserDefaults
     
     - parameter userDefaults: The UserDefaults instance used as a backing store
     */
    public init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }
    
    /// A Boolean value that determines whether the onboarding screen have displayed.
    public var hasOnboarded: Bool {
        get { return userDefaults.bool(forKey: Key.hasOnboarded.rawValue) }
        set { userDefaults.set(newValue, forKey: Key.hasOnboarded.rawValue) }
    }
}
