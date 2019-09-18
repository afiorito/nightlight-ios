import Foundation

/// A view model for handling sign up state.
public class SignUpViewModel {
    public typealias Dependencies = StyleManaging & AuthServiced
    
    /// The required dependencies.
    private let dependencies: Dependencies
    
    /// The delegate object that handles user interface updates.
    public weak var uiDelegate: AuthViewModelUIDelegate?
    
    /// The delegate object that handles navigation events.
    public weak var navigationDelegate: AuthNavigationDelegate?
    
    /// The active theme.
    public var theme: Theme {
        return dependencies.styleManager.theme
    }
    
    public init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    /**
    Sign up a user.
    
    - parameter credentials: the sign up credentials of the user.
    */
    public func signUp(with credentials: SignUpCredentials) {
        uiDelegate?.didBeginAuthenticating()
        dependencies.authService.signUp(with: credentials) { [weak self] signUpResult in
            DispatchQueue.main.async { self?.uiDelegate?.didEndAuthenticating() }
            switch signUpResult {
            case .success:
                DispatchQueue.main.async { self?.navigationDelegate?.didAuthenticate() }
            case .failure(let error):
                DispatchQueue.main.async { self?.uiDelegate?.didFailToAuthenticate(with: error) }
            }
        }
    }
    
    /**
     Select a policy to display with a specified url.
     
     - parameter url: The url of the policy to display.
     */
    public func selectPolicy(with url: URL) {
        navigationDelegate?.showPolicy(with: url)
    }
    
    /**
     Sign in instead of signing up a user.
     */
    public func signIn() {
        navigationDelegate?.goToSignIn()
        uiDelegate?.clearFields()
    }
}
