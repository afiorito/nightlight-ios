import UIKit

/// Main application coordinator.
public class AppCoordinator: Coordinator {
    public var children: [Coordinator] = []
    
    private(set) var window: UIWindow
    
    public init() {
        window = UIWindow(frame: UIScreen.main.bounds)
    }
    
    public func start() {
        
        // TODO:
        // check if tutorial has displayed
        
        // check if user is already authenticated
        
        // if user is not signed in already, show login
        
        window.rootViewController = SignInViewController(dependencies: DependencyContainer())
        
        window.makeKeyAndVisible()
    }

}
