import Foundation

public class SignInViewModel {
    
    public typealias Dependencies = StyleManaging & AuthServiced
    
    private let dependencies: Dependencies
    
    public var theme: Theme {
        return dependencies.styleManager.theme
    }
    
    public init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    public func signIn(with credentials: SignInCredentials, result: @escaping (Result<Bool, AuthError>) -> Void) {
        dependencies.authService.signIn(with: credentials) { signInResult in
            DispatchQueue.main.async {
                result(signInResult)
            }
        }
    }
}
