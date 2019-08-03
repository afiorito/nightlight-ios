import Foundation

public class SignUpViewModel {
    
    public typealias Dependencies = StyleManaging & AuthServiced
    
    private let dependencies: Dependencies
    
    public var theme: Theme {
        return dependencies.styleManager.theme
    }
    
    public init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    public func signUp(with credentials: SignUpCredentials, result: @escaping (Result<Bool, AuthError>) -> Void) {
        dependencies.authService.signUp(with: credentials) { signUpResult in
            DispatchQueue.main.async {
                result(signUpResult)
            }
        }
    }
}
