import UIKit

/// Main application coordinator.
public class AppCoordinator: NSObject, Coordinator {
    public weak var parent: Coordinator?
    public var children: [Coordinator] = []
    
    /// The required dependencies.
    private let dependencies: DependencyContainer
    
    /// The key window of the application.
    private(set) var window: UIWindow
    
    private weak var tabBarController: NLTabBarController?

    /// A boolean representing whether a user has signed in previously.
    private var isSignedIn: Bool {
        let accessToken = try? dependencies.keychainManager.string(forKey: KeychainKey.accessToken.rawValue)
        return accessToken != nil
    }
    
    private var isInitialLaunch = false
    
    public init(dependencies: DependencyContainer) {
        self.dependencies = dependencies
        window = UIWindow(frame: UIScreen.main.bounds)
        
        super.init()
        
        dependencies.userNotificationCenter.delegate = self
        
        dependencies
            .notificationCenter
            .addObserver(self,
                         selector: #selector(handleUnauthorized),
                         name: Notification.Name(rawValue: NLNotification.unauthorized.rawValue),
                         object: nil)
    }
    
    deinit {
        dependencies
            .notificationCenter
            .removeObserver(self, name: Notification.Name(rawValue: NLNotification.unauthorized.rawValue), object: nil)
    }
    
    public func selectViewController(at index: Int) {
        tabBarController?.selectedIndex = index
    }
    
    public func addNotificationBadge() {
        tabBarController?.addBadge(at: 3)
    }
    
    public func start() {
        dependencies.styleManager.theme = dependencies.userDefaultsManager.theme
        
        let splashScreenViewController = SplashScreenViewController()
        window.rootViewController = splashScreenViewController
        
        window.makeKeyAndVisible()
        
        fetchUserInfo {}
        
        if !self.dependencies.userDefaultsManager.hasOnboarded {
            // Onboarding is only shown on first app load.
            // Since keychain values are persisted even when the app is uninstalled,
            // clear the keychain when the app is reinstalled and loaded for the first time.
            try? self.dependencies.keychainManager.removeAllKeys()
            self.isInitialLaunch = true

            let onboardViewController = OnboardViewController()
            onboardViewController.delegate = self
            splashScreenViewController.initialViewController = onboardViewController
            splashScreenViewController.showInitialViewController()
        } else if self.isSignedIn {
            let viewController = self.prepareMainApplication()
            splashScreenViewController.initialViewController = viewController
        } else {
            let authCoordinator = AuthCoordinator(rootViewController: splashScreenViewController,
                                                  dependencies: self.dependencies,
                                                  authMethod: .signIn)
            self.addChild(authCoordinator)
            authCoordinator.start()
        }

        splashScreenViewController.showInitialViewController()
        
    }
    
    @objc private func handleUnauthorized(_ notification: Notification) {
        try? dependencies.keychainManager.remove(key: KeychainKey.refreshToken.rawValue)
        try? dependencies.keychainManager.remove(key: KeychainKey.accessToken.rawValue)
        
        let authCoordinator = AuthCoordinator(rootViewController: window.rootViewController, dependencies: dependencies, authMethod: .signIn)
        addChild(authCoordinator)
        
        UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: { 
            UIView.setAnimationsEnabled(false)
            authCoordinator.start()
            UIView.setAnimationsEnabled(true)
        })
    }
    
    private func prepareMainApplication() -> UIViewController {
        let placeholderViewController = UIViewController()
        placeholderViewController.tabBarItem = UITabBarItem(title: "Post", image: UIImage(named: "tb_post"), tag: 0)
        
        let coordinators: [TabBarCoordinator] = [
            RecentMessagesCoordinator(rootViewController: MainNavigationController(), dependencies: self.dependencies),
            SearchCoordinator(rootViewController: MainNavigationController(), dependencies: self.dependencies),
            NotificationsCoordinator(rootViewController: MainNavigationController(), dependencies: self.dependencies),
            ProfileCoordinator(rootViewController: MainNavigationController(), dependencies: self.dependencies)
        ]

        for coordinator in coordinators {
            addChild(coordinator)
            coordinator.start()
        }
        
        let tabBarController = NLTabBarController()
        tabBarController.delegate = self
        tabBarController.viewControllers = [
            coordinators[0].rootViewController,
            coordinators[1].rootViewController,
            placeholderViewController,
            coordinators[2].rootViewController,
            coordinators[3].rootViewController
        ]
        
        self.tabBarController = tabBarController
        
        return tabBarController
    }
    
    public func childDidFinish(_ child: Coordinator) {
        removeChild(child)
        
        if child is AuthCoordinator {
            if isInitialLaunch {
                let viewModel = PermissionViewModel(dependencies: dependencies)
                
                let notificationPermissionViewController = NotificationPermissionViewController(viewModel: viewModel)
                notificationPermissionViewController.delegate = self
                
                animateRootViewController(notificationPermissionViewController)
                
            } else {
                animateRootViewController(prepareMainApplication())
            }
        }
    }
    
    private func fetchUserInfo(completion: @escaping () -> Void) {
        dependencies.peopleService.getPerson { [weak self] result in
            switch result {
            case .success(let person):
                try? self?.dependencies.keychainManager.set(person.tokens, forKey: KeychainKey.tokens.rawValue)
                try? self?.dependencies.keychainManager.set(person.username, forKey: KeychainKey.username.rawValue)
                try? self?.dependencies.keychainManager.set(person.createdAt.timeIntervalSince1970, forKey: KeychainKey.userCreatedAt.rawValue)
            case .failure: break
            }
            
            DispatchQueue.main.async { completion() }
        }
    }
    
    private func animateRootViewController(_ rootViewController: UIViewController) {
        // animate resetting the view controller stack
        UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: { [weak self] in
            UIView.setAnimationsEnabled(false)
            self?.window.rootViewController = rootViewController
            UIView.setAnimationsEnabled(true)
        })
    }

}

// MARK: - PermissionViewController Delegate

extension AppCoordinator: PermissionViewControllerDelegate {
    public func permissionViewController(_ permissionViewController: PermissionViewController, didFinish success: Bool) {
        animateRootViewController(prepareMainApplication())
    }
    
}

// MARK: - UITabBarController Delegate

extension AppCoordinator: UITabBarControllerDelegate {
    public func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        if viewController.tabBarItem.title == "Post" {
            let coordinator = SendMessageCoordinator(rootViewController: MainNavigationController(), dependencies: self.dependencies)
            addChild(coordinator)
            coordinator.start()
            
            tabBarController.present(coordinator.rootViewController, animated: true)
            
            return false
        }
        
        return true
    }
}

// MARK: - OnboardViewController Delegate

extension AppCoordinator: OnboardViewControllerDelegate {
    public func onboardViewControllerDidProceedAsNewUser(_ onboardViewController: OnboardViewController) {
        dependencies.userDefaultsManager.hasOnboarded = true
        let authCoordinator = AuthCoordinator(rootViewController: onboardViewController, dependencies: dependencies, authMethod: .signUp)
        addChild(authCoordinator)
        authCoordinator.start()
        
    }
    
    public func onboardViewControllerDidProceedAsExistingUser(_ onboardViewController: OnboardViewController) {
        dependencies.userDefaultsManager.hasOnboarded = true
        
        let authCoordinator = AuthCoordinator(rootViewController: onboardViewController, dependencies: dependencies, authMethod: .signIn)
        addChild(authCoordinator)
        authCoordinator.start()
    }
    
}

extension AppCoordinator: UNUserNotificationCenterDelegate {
    public func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        selectViewController(at: 3)
        
        completionHandler()
    }
}
