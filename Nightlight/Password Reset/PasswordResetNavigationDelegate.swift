/// Methods for handling password reset navigation events.
public protocol PasswordResetNavigationDelegate: class {
    /**
     Tells the delegate that the user is no longer resetting their password.
     */
    func didStopResettingPassword()
    
    /**
     Tells the delegate that the user successfully reset their password.
     */
    func didResetPassword()
    
    /**
     Tells the delegate that the user failed to reset their password.
     */
    func didFailResettingPassword()
}
