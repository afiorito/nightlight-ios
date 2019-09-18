/// Methods for updating the user interface from an auth view model.
public protocol AuthViewModelUIDelegate: class {
    /**
     Tells the delegate that authentication began.
     */
    func didBeginAuthenticating()
    
    /**
     Tells the delegate that authentication stopped.
     */
    func didEndAuthenticating()
    
    /**
     Tells the delegate that authentication failed.
     
     - parameter error: The error for the authentication failure.
     */
    func didFailToAuthenticate(with error: AuthError)
    
    /**
     Tells the delegate to clear its input fields.
     */
    func clearFields()
}
