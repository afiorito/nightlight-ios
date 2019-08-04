import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    private var coordinator: AppCoordinator?
    private let dependencies = DependencyContainer()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        application.registerForRemoteNotifications()
        
        coordinator = AppCoordinator(dependencies: dependencies)
        coordinator?.start()

        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        dependencies.peopleService.updateDeviceToken(deviceToken) { _ in }
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
