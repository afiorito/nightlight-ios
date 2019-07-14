import Foundation

/// A dependency container to inject into other objects.
public struct DependencyContainer: StyleManaging, UserDefaultsManaging, KeychainManaging, KeyboardManaging, AuthServiced, MessageServiced {
    public var styleManager = StyleManager()
    public var userDefaultsManager = UserDefaultsManager()
    public var keychainManager = KeychainManager()
    public var keyboardManager = KeyboardManager()
    public var authService: AuthService
    public var messageService: MessageService
    
    init() {
        let httpClient = HttpClient()
        let authorizedHttpClient = AuthorizedHttpClient(keychainManager: keychainManager)
        
        self.authService = AuthService(httpClient: httpClient, keychainManager: keychainManager)
        self.messageService = MessageService(httpClient: authorizedHttpClient)
    }
}
