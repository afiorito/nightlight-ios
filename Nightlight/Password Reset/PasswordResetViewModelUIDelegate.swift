/// Methods for updating the user interface from an `PasswordResetViewModel`.
public protocol PasswordResetViewModelUIDelegate: class {
    /**
     Tells the delegate that the reset email began sending.
     */
    func didBeginSendingResetEmail()

    /**
     Tells the delegate that the reset email sent successfully.
     */
    func didSendResetEmail()
    
    /**
     Tells the delegate that the reset email stopped sending.
     */
    func didEndSendingResetEmail()
    
    /**
     Tells the delegate that the reset email failed to send.
     */
    func didFailSendingResetEmail(with error: AuthError)
    
    /**
     Tells the delegate that the password began resetting.
     */
    func didBeginResetingPassword()
    
    /**
     Tells the delegate that the password failed to reset.
     */
    func didFailResettingPassword(with error: AuthError)
    
    /**
     Tells the delegate that the password stopped resetting.
     */
    func didEndResettingPassword()
}
