/// Methods for handling account settings navigation events.
public protocol AccountSettingsNavigationDelegate: class {
    /**
     Tells the delegate that the user is no viewing the account settings.
     */
    func didFinishViewingAccountSettings()
    
    /**
     Tells the delegate to show the change email view.
     */
    func showChangeEmail()
    
    /**
     Tells the delegate the email changed successfully.
     */
    func didChangeEmail()
    
    /**
     Tells the delegate that changing the email failed.
     */
    func didFailChangeEmail()
}
