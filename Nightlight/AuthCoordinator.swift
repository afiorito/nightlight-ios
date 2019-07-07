import UIKit

public class AuthCoordinator: Coordinator {
    public enum AuthMethod {
        case signUp, signIn
    }
    public typealias Dependencies = UserDefaultsManaging

    public weak var parent: Coordinator?
    
    public var children = [Coordinator]()
    
    private let rootViewController: UIViewController
    
    lazy var signInViewController: SignInViewController = {
        let signInViewController = SignInViewController(dependencies: dependencies as! SignInViewController.Dependencies)
        signInViewController.delegate = self
        return signInViewController
    }()
    
    lazy var signUpViewController: SignUpViewController = {
        let signUpViewController = SignUpViewController(dependencies: dependencies as! SignUpViewController.Dependencies)
        signUpViewController.delegate = self
        
        return signUpViewController
    }()
    
    private let dependencies: Dependencies
    
    public let authMethod: AuthMethod
    
    public init(rootViewController: UIViewController, dependencies: Dependencies, authMethod: AuthMethod) {
        self.rootViewController = rootViewController
        self.dependencies = dependencies
        self.authMethod = authMethod
    }
    
    public func start() {
        let authViewController: UIViewController
        
        switch authMethod {
        case .signIn:
            authViewController = signInViewController
        case .signUp:
            authViewController = signUpViewController
        }
        
        if let splashScreenViewController = rootViewController as? SplashScreenViewController {
            splashScreenViewController.initialViewController = authViewController
            splashScreenViewController.showInitialViewController()
        } else {
            authViewController.modalPresentationStyle = .fullScreen
            rootViewController.show(authViewController, sender: rootViewController)
        }
    }
    
    private func showOtherViewController(currentViewController: UIViewController) {
        let otherViewController: UIViewController
        
        switch authMethod {
        case .signIn:
            otherViewController = signUpViewController
        case .signUp:
            otherViewController = signInViewController
        }
        
        // Avoid continously presenting more view controllers if going between sign in and sign up
        if currentViewController === otherViewController {
            currentViewController.dismiss(animated: true)
        } else {
            currentViewController.present(otherViewController, animated: true)
        }
    }
}

extension AuthCoordinator: SignUpViewControllerDelegate, SignInViewControllerDelegate {
    public func signInViewControllerDidTapSignUp(_ signInViewController: SignInViewController) {
        showOtherViewController(currentViewController: signInViewController)
    }
    
    public func signUpViewControllerDidTapSignIn(_ signUpViewController: SignUpViewController) {
        showOtherViewController(currentViewController: signUpViewController)
    }
    
}
