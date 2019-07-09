import Foundation

/// A dependency container to inject into other objects.
public struct DependencyContainer: StyleManaging, UserDefaultsManaging, KeychainManaging, KeyboardManaging, AuthServiced {
    public var styleManager = StyleManager()
    public var userDefaultsManager = UserDefaultsManager()
    public var keychainManager = KeychainManager()
    public var keyboardManager = KeyboardManager()
    public var authService: AuthService
    
    init() {
        let httpClient = HttpClient()
        
        self.authService = AuthService(httpClient: httpClient, keychainManager: keychainManager)
        
    }
}
