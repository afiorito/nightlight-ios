import Foundation

/// A view model for handling sign in state.
public class SignInViewModel {
    public typealias Dependencies = StyleManaging & AuthServiced
    
    /// The required dependencies.
    private let dependencies: Dependencies
    
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
     - parameter result: the sign in result. The result is true if sign in is successful.
     */
    public func signIn(with credentials: SignInCredentials, result: @escaping (Result<Bool, AuthError>) -> Void) {
        dependencies.authService.signIn(with: credentials) { signInResult in
            DispatchQueue.main.async { result(signInResult) }
        }
    }
}
