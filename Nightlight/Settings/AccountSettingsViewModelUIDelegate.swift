/// Methods for updating the user interface from an `AccountSettingsViewModel`.
public protocol AccountSettingsViewModelUIDelegate: class {
    /**
     Tells the delegate that fetching the account completed successfully.
     */
    func didFetchAccount()
    
    /**
     Tells the delegate that fetching the account failed.
     
     - parameter error: The error for the fetching failure.
     */
    func didFailToFetchAccount(with error: Error)
    
    /**
     Tells the delegate the email changed successfully.
     */
    func didChangeEmail()

    /**
     Tells the delegate that changing the email failed.
     */
    func didFailChangeEmail(with error: PersonError)

}
