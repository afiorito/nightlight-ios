import Foundation

/// A view model for handling sign up state.
public class SignUpViewModel {
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
    Sign up a user.
    
    - parameter credentials: the sign up credentials of the user.
    - parameter result: the sign up result. The result is true if sign up is successful.
    */
    public func signUp(with credentials: SignUpCredentials, result: @escaping (Result<Bool, AuthError>) -> Void) {
        dependencies.authService.signUp(with: credentials) { signUpResult in
            DispatchQueue.main.async { result(signUpResult) }
        }
    }
}
