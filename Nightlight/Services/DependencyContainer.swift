import Foundation
import UserNotifications

public protocol UserNotificationManaging {
    var userNotificationCenter: UNUserNotificationCenter { get }
}

/// A dependency container to inject into other objects.
public struct DependencyContainer: StyleManaging,
    UserDefaultsManaging, KeychainManaging, NotificationObserving, UserNotificationManaging, KeyboardManaging, IAPManaging, AuthServiced,
    MessageServiced, PeopleServiced, UserNotificationServiced {
    public var userDefaultsManager = UserDefaultsManager()
    public var keyboardManager = KeyboardManager()
    public var styleManager = StyleManager.default
    public var notificationCenter = NotificationCenter.default
    public var userNotificationCenter = UNUserNotificationCenter.current()
    public var keychainManager: KeychainManager
    public var authService: AuthService
    public var messageService: MessageService
    public var peopleService: PeopleService
    public var notificationService: UserNotificationService
    public var iapManager: IAPManager
    
    init() {
        let keychainManager = KeychainManager()
        self.keychainManager = keychainManager

        let httpClient = HttpClient()
        let authorizedHttpClient = AuthorizedHttpClient(keychainManager: keychainManager)

        self.authService = AuthService(httpClient: httpClient, keychainManager: keychainManager)
        self.messageService = MessageService(httpClient: authorizedHttpClient)
        self.notificationService = UserNotificationService(httpClient: authorizedHttpClient)
        
        let peopleService = PeopleService(httpClient: authorizedHttpClient, keychainManager: keychainManager)
        self.peopleService = peopleService
        
        let apiManagerDependencies: IAPManager.Dependencies = {
            struct Dependencies: PeopleServiced, KeychainManaging {
                var peopleService: PeopleService
                var keychainManager: KeychainManager
            }
            return Dependencies(peopleService: peopleService, keychainManager: keychainManager)
        }()
        
        self.iapManager = IAPManager(productIdentifiers: IAPIdentifier.allCases.map { $0.fullIdentifier }, dependencies: apiManagerDependencies)
    }
}
