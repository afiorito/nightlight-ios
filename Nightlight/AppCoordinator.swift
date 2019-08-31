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
    public var isSignedIn: Bool {
        let accessToken = try? dependencies.keychainManager.string(for: KeychainKey.accessToken.rawValue)
        return accessToken != nil
    }
    
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
    
    /**
     Select the tab of the tab bar controller at a specified index.
     
     - parameter index: the index of the tab to select.
     */
    public func selectViewController(at index: Int) {
        tabBarController?.selectedIndex = index
    }
    
    /**
     Add a badge to the notification tab of the tab bar.
     */
    public func addNotificationBadge() {
        tabBarController?.addBadge(at: 3)
    }
    
    public func start() {
        dependencies.styleManager.theme = dependencies.userDefaultsManager.theme
        
        let splashScreenViewController = SplashScreenViewController()
        window.rootViewController = splashScreenViewController
        
        window.makeKeyAndVisible()
        
        if !self.dependencies.userDefaultsManager.hasOnboarded {
            // Onboarding is only shown on first app load.
            // Since keychain values are persisted even when the app is uninstalled,
            // clear the keychain when the app is reinstalled and loaded for the first time.
            try? self.dependencies.keychainManager.removeAllKeys()

            let onboardViewController = OnboardViewController()
            onboardViewController.delegate = self
            splashScreenViewController.initialViewController = onboardViewController
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
    
    /**
     Handle an unauthorized notification. For when a user cannot be authenticated.
     
     - parameter notification: the unauthorized notification.
     */
    @objc private func handleUnauthorized(_ notification: Notification) {
        try? dependencies.keychainManager.remove(key: KeychainKey.refreshToken.rawValue)
        try? dependencies.keychainManager.remove(key: KeychainKey.accessToken.rawValue)
        try? dependencies.keychainManager.remove(key: KeychainKey.tokens.rawValue)
        
        let authCoordinator = AuthCoordinator(rootViewController: nil, dependencies: dependencies, authMethod: .signIn)
        addChild(authCoordinator)
        authCoordinator.start()
        
        animateRootViewController(authCoordinator.rootViewController!)
    }
    
    /**
     Prepare the main application after successful authentication.
     */
    private func prepareMainApplication() -> UIViewController {
        fetchUserInfo {}
        let placeholderViewController = UIViewController()
        placeholderViewController.tabBarItem = UITabBarItem(title: Strings.message.postMessageTabTitle, image: UIImage.tab.post, tag: 0)
        
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
            // update the device token after sign in or sign up.
            if let token = dependencies.userDefaultsManager.deviceToken {
                dependencies.peopleService.updateDeviceToken(token) { _ in }
            }
            
            hasShownNotificationPrompt { [weak self] (result) in
                guard let self = self else { return }

                switch result {
                case .success(let hasShown):
                    if hasShown {
                        self.animateRootViewController(self.prepareMainApplication())
                    } else {
                        let viewModel = PermissionViewModel(dependencies: self.dependencies)
                        
                        let notificationPermissionViewController = NotificationPermissionViewController(viewModel: viewModel)
                        notificationPermissionViewController.delegate = self
                        
                        self.animateRootViewController(notificationPermissionViewController)
                    }
                default: self.animateRootViewController(self.prepareMainApplication())
                }
            }
        }
    }
    
    private func hasShownNotificationPrompt(result: @escaping (Result<Bool, Error>) -> Void) {
        dependencies.userNotificationCenter.getNotificationSettings { (settings) in
            DispatchQueue.main.async {
                result(.success(settings.authorizationStatus != .notDetermined))
            }
        }
    }
    
    /**
     Cache user info for offline use.
     
     - parameter completion: A block called when after completion of retrieving the user info.
     */
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
    
    /**
     Animate the appearance root view controller of the window.
     
     - parameter rootViewController: the new root view controller to animate.
     */
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
        
        if viewController.tabBarItem.title == Strings.message.postMessageTabTitle {
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

// MARK: - UNUserNotificationCenter Delegate

extension AppCoordinator: UNUserNotificationCenterDelegate {
    public func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        selectViewController(at: 3)
        
        completionHandler()
    }
}
