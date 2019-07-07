import UIKit

/// Main application coordinator.
public class AppCoordinator: Coordinator {
    public weak var parent: Coordinator?
    
    public var children: [Coordinator] = []
    
    public typealias Dependencies = UserDefaultsManaging

    private(set) var window: UIWindow
    
    private let dependencies: Dependencies
    
    private let rootViewController = SplashScreenViewController()
    
    public init(dependencies: Dependencies) {
        self.dependencies = dependencies
        window = UIWindow(frame: UIScreen.main.bounds)
    }
    
    public func start() {
        // TODO:
        // check if tutorial has displayed
        let isAuthenticated = false
        
        if !dependencies.userDefaultsManager.hasOnboarded {
            let dependencies = self.dependencies as! OnboardViewController.Dependencies
            let onboardViewController = OnboardViewController(dependencies: dependencies)
            onboardViewController.delegate = self
            rootViewController.initialViewController = onboardViewController
            rootViewController.showInitialViewController()
        } else if isAuthenticated {
        
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
