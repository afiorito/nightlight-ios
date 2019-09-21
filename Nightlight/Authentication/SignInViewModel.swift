import Foundation

/// A view model for handling sign in state.
public class SignInViewModel {
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
     Sign in a user.
     
     - parameter credentials: the sign in credentials of the user.
     */
    public func signIn(with credentials: SignInCredentials) {
        uiDelegate?.didBeginAuthenticating()
        dependencies.authService.signIn(with: credentials) { [weak self] signInResult in
            DispatchQueue.main.async { self?.uiDelegate?.didEndAuthenticating() }
            switch signInResult {
            case .success:
                DispatchQueue.main.async { self?.navigationDelegate?.didAuthenticate() }
            case .failure(let error):
                DispatchQueue.main.async { self?.uiDelegate?.didFailToAuthenticate(with: error) }
            }
        }
    }
    
    /**
     Sign up instead of signing in a user.
     */
    public func signUp() {
        navigationDelegate?.goToSignUp()
    }
}
