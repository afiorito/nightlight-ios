import UIKit

/// Main application coordinator.
public class AppCoordinator: Coordinator {
    public weak var parent: Coordinator?
    public var children: [Coordinator] = []
    
    /// The required dependencies.
    private let dependencies: DependencyContainer
    
    /// The key window of the application.
    private(set) var window: UIWindow

    /// A boolean representing whether a user has signed in previously.
    private var isSignedIn: Bool {
        let accessToken = try? dependencies.keychainManager.string(forKey: KeychainKey.accessToken.rawValue)
        return accessToken != nil
    }
    
    public init(dependencies: DependencyContainer) {
        self.dependencies = dependencies
        window = UIWindow(frame: UIScreen.main.bounds)
    }
    
    public func start() {
        let splashScreenViewController = SplashScreenViewController()
        window.rootViewController = splashScreenViewController
        
        if !dependencies.userDefaultsManager.hasOnboarded {
            // Onboarding is only shown on first app load.
            // Since keychain values are persisted even when the app is uninstalled,
            // clear the keychain when the app is reinstalled and loaded for the first time.
            try? dependencies.keychainManager.removeAllKeys()
            
            let onboardViewController = OnboardViewController(dependencies: self.dependencies)
            onboardViewController.delegate = self
            splashScreenViewController.initialViewController = onboardViewController
            splashScreenViewController.showInitialViewController()
        } else if isSignedIn {
            let viewController = prepareMainApplication()
            splashScreenViewController.initialViewController = viewController
        } else {
            let authCoordinator = AuthCoordinator(rootViewController: splashScreenViewController, dependencies: dependencies, authMethod: .signIn)
            addChild(authCoordinator)
            authCoordinator.start()
        }
        
        splashScreenViewController.showInitialViewController()
        
        window.makeKeyAndVisible()
    }
    
    private func prepareMainApplication() -> UIViewController {
        let coordinators: [TabBarCoordinator] = [
            RecentMessagesCoordinator(
                rootViewController: MainNavigationController(dependencies: self.dependencies),
                dependencies: self.dependencies),
            SearchCoordinator(dependencies: self.dependencies),
            SendMessageCoordinator(dependencies: self.dependencies),
            NotificationsCoordinator(
                rootViewController: MainNavigationController(dependencies: self.dependencies),
                dependencies: self.dependencies),
            ProfileCoordinator(dependencies: self.dependencies)
        ]

        for coordinator in coordinators {
            addChild(coordinator)
            coordinator.start()
        }
        
        let tabBarController = NLTabBarController(dependencies: self.dependencies)
        tabBarController.viewControllers = coordinators.map { $0.rootViewController }
        
        return tabBarController
    }
    
    public func childDidFinish(_ child: Coordinator) {
        removeChild(child)
        
        if child is AuthCoordinator {
            let viewController = prepareMainApplication()
            
            // animate resetting the view controller stack
            UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: { [weak self] in
                UIView.setAnimationsEnabled(false)
                self?.window.rootViewController = viewController
                UIView.setAnimationsEnabled(true)
            })
        }
    }

}

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
