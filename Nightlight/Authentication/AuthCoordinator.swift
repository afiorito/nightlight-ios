import UIKit

/// A coordinator for authentication flow.
public class AuthCoordinator: Coordinator {
    public typealias Dependencies = UserDefaultsManaging
    public weak var parent: Coordinator?
    public var children = [Coordinator]()

    /// A value representing the method of authentication of a user.
    public enum AuthMethod {
        case signUp, signIn
    }
    
    /// The required dependencies.
    private let dependencies: Dependencies

    /// The starting authentication method.
    public let authMethod: AuthMethod
    
    public init(rootViewController: UIViewController?, dependencies: Dependencies, authMethod: AuthMethod) {
        self.rootViewController = rootViewController
        self.dependencies = dependencies
        self.authMethod = authMethod
    }
    
    /// The root view controller of the application.
    private(set) var rootViewController: UIViewController?
    
    /// The view controller used to sign in a user.
    private var signInViewController: SignInViewController {
        let viewModel = SignInViewModel(dependencies: dependencies as! SignInViewModel.Dependencies)
        let signInViewController = SignInViewController(viewModel: viewModel)
        signInViewController.delegate = self
        
        return signInViewController
    }
    
    /// The view controller used to sign up a user.
    private var signUpViewController: SignUpViewController {
        let viewModel = SignUpViewModel(dependencies: dependencies as! SignUpViewModel.Dependencies)
        let signUpViewController = SignUpViewController(viewModel: viewModel)
        signUpViewController.delegate = self
        
        return signUpViewController
    }

    public func start() {
        let authViewController: UIViewController
        
        switch authMethod {
        case .signIn:
            authViewController = signInViewController
        case .signUp:
            authViewController = signUpViewController
        }
        
        // An auth view controller may become root during reauthentication.
        if rootViewController == .none {
            rootViewController = authViewController
        } else if let splashScreenViewController = rootViewController as? SplashScreenViewController {
            splashScreenViewController.initialViewController = authViewController
        } else {
            authViewController.modalPresentationStyle = .fullScreen
            rootViewController?.show(authViewController, sender: rootViewController)
        }
    }
    
    /**
     Show the other authentication view controller.
     
     Avoids adding more view controllers to the stack.
     
     - parameter currentViewController: the current presented view controller.
     */
    private func showOtherViewController(currentViewController: UIViewController) {
        let otherViewController: UIViewController
        
        switch authMethod {
        case .signIn:
            otherViewController = signUpViewController
        case .signUp:
            otherViewController = signInViewController
        }
        
        // Avoid continously presenting more view controllers if going between sign in and sign up
        if type(of: currentViewController) == type(of: otherViewController) {
            currentViewController.dismiss(animated: true)
        } else {
            currentViewController.present(otherViewController, animated: true)
        }
    }
}

// MARK: Auth ViewController Delegates

extension AuthCoordinator: SignUpViewControllerDelegate, SignInViewControllerDelegate {
    public func signUpViewController(_ signUpViewController: SignUpViewController, didTapPolicyWith url: URL) {
        let webContentViewController = WebContentViewController(url: url)
        signUpViewController.present(MainNavigationController(rootViewController: webContentViewController), animated: true)
    }
    
    public func signInViewControllerDidSignIn(_ signInViewController: SignInViewController) {
        parent?.childDidFinish(self)
    }
    
    public func signUpViewControllerDidSignUp(_ signUpViewController: SignUpViewController) {
        parent?.childDidFinish(self)
    }
    
    public func signInViewControllerDidTapSignUp(_ signInViewController: SignInViewController) {
        showOtherViewController(currentViewController: signInViewController)
    }
    
    public func signUpViewControllerDidTapSignIn(_ signUpViewController: SignUpViewController) {
        showOtherViewController(currentViewController: signUpViewController)
    }
    
}
