import Foundation

/// A view model for handling password reset.
public class PasswordResetViewModel {
    public typealias Dependencies = AuthServiced & StyleManaging
    
    /// The required dependencies.
    private let dependencies: Dependencies
    
    /// The delegate object that handles user interface updates.
    public weak var uiDelegate: PasswordResetViewModelUIDelegate?
    
    /// The delegate object that handles navigation events.
    public weak var navigationDelegate: PasswordResetNavigationDelegate?
    
    public init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
 
    /**
     Send a password reset email to the specified email address.
     
     - parameter email: The destination email to send the passwork reset email to.
     */
    public func sendPasswordResetEmail(to email: String) {
        uiDelegate?.didBeginSendingResetEmail()
        dependencies.authService.sendPasswordResetEmail(to: email) { emailResult in
            switch emailResult {
            case .success:
                DispatchQueue.main.async { [weak self] in self?.uiDelegate?.didSendResetEmail() }
            case .failure(let error):
                DispatchQueue.main.async { [weak self] in self?.uiDelegate?.didFailSendingResetEmail(with: error) }
            }
            
            DispatchQueue.main.async { [weak self] in self?.uiDelegate?.didEndSendingResetEmail() }
        }
    }
    
    /**
     Reset a user's password
     
     - parameter newPassword: The new password of the user.
     - parameter token: The reset password token.
     */
    public func resetPassword(_ newPassword: String, token: String) {
        uiDelegate?.didBeginResetingPassword()
        dependencies.authService.resetPassword(newPassword, token: token) { passwordResult in
            switch passwordResult {
            case .success:
                DispatchQueue.main.async { [weak self] in self?.navigationDelegate?.didResetPassword() }
            case .failure(let error):
                switch error {
                case .invalidResetToken:
                    DispatchQueue.main.async { [weak self] in self?.navigationDelegate?.didFailResettingPassword() }
                default:
                    DispatchQueue.main.async { [weak self] in self?.uiDelegate?.didFailResettingPassword(with: error) }
                }
            }
            
            DispatchQueue.main.async { [weak self] in self?.uiDelegate?.didEndResettingPassword() }
        }
    }
    
    /**
     Stop resetting password.
     */
    public func finish() {
        navigationDelegate?.didStopResettingPassword()
    }
}
