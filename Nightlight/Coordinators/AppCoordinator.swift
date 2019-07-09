import UIKit

/// Main application coordinator.
public class AppCoordinator: Coordinator {
    public typealias Dependencies = UserDefaultsManaging & KeychainManaging
    
    public weak var parent: Coordinator?
    public var children: [Coordinator] = []
    
    /// The required dependencies.
    private let dependencies: Dependencies
    
    /// The key window of the application.
    private(set) var window: UIWindow
    
    /// The root view controller of the application.
    private let rootViewController = SplashScreenViewController()
    
    /// A boolean representing whether a user has signed in previously.
    private var isSignedIn: Bool {
        let accessToken = try? dependencies.keychainManager.string(forKey: KeychainKey.accessToken.rawValue)
        return accessToken != nil
    }
    
    public init(dependencies: Dependencies) {
        self.dependencies = dependencies
        window = UIWindow(frame: UIScreen.main.bounds)
    }
    
    public func start() {
        if !dependencies.userDefaultsManager.hasOnboarded {
            // Onboarding is only shown on first app load.
            // Since keychain values are persisted even when the app is uninstalled,
            // clear the keychain when the app is reinstalled and loaded for the first time.
            try? dependencies.keychainManager.removeAllKeys()
            
            let dependencies = self.dependencies as! OnboardViewController.Dependencies
            let onboardViewController = OnboardViewController(dependencies: dependencies)
            onboardViewController.delegate = self
            rootViewController.initialViewController = onboardViewController
            rootViewController.showInitialViewController()
        } else if isSignedIn {
            // show home view controller
            print("Welcome to my home")
        } else {
            let authCoordinator = AuthCoordinator(rootViewController: rootViewController, dependencies: dependencies, authMethod: .signIn)
            addChild(authCoordinator)
            authCoordinator.start()
        }
        
        window.rootViewController = rootViewController
        
        window.makeKeyAndVisible()
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
