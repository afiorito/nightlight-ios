import Foundation

/// A dependency container to inject into other objects.
public struct DependencyContainer: StyleManaging,
    UserDefaultsManaging, KeychainManaging, NotificationObserving, KeyboardManaging, IAPManaging, AuthServiced,
    MessageServiced, PeopleServiced, UserNotificationServiced {
    public var styleManager = StyleManager.default
    public var userDefaultsManager = UserDefaultsManager()
    public var keychainManager = KeychainManager()
    public var keyboardManager = KeyboardManager()
    public var notificationCenter = NotificationCenter.default
    public var authService: AuthService
    public var messageService: MessageService
    public var peopleService: PeopleService
    public var notificationService: UserNotificationService
    public var iapManager = IAPManager(productIdentifiers: IAPIdentifier.allCases.map { $0.fullIdentifier })
    
    init() {
        let httpClient = HttpClient()
        let authorizedHttpClient = AuthorizedHttpClient(keychainManager: keychainManager)
        
        self.authService = AuthService(httpClient: httpClient, keychainManager: keychainManager)
        self.messageService = MessageService(httpClient: authorizedHttpClient)
        self.peopleService = PeopleService(httpClient: authorizedHttpClient, keychainManager: keychainManager)
        self.notificationService = UserNotificationService(httpClient: authorizedHttpClient)
    }
}
