import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    private var coordinator: AppCoordinator?
    private let dependencies = DependencyContainer()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        coordinator = AppCoordinator(dependencies: dependencies)
        coordinator?.start()

        application.registerForRemoteNotifications()

        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let newToken = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        let currentToken = dependencies.userDefaultsManager.deviceToken
        
        dependencies.userDefaultsManager.deviceToken = newToken
        
        if let coordinator = coordinator, coordinator.isSignedIn, newToken != currentToken {
            dependencies.peopleService.updateDeviceToken(newToken) { _ in }
        }
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        coordinator?.addNotificationBadge()
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        if UIApplication.shared.applicationIconBadgeNumber > 0 {
            coordinator?.addNotificationBadge()
        }
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

}
