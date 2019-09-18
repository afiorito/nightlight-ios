/// Methods for handling settings navigation events.
public protocol SettingsNavigationDelegate: class {
    /**
     Tells the delegate that the user is no viewing the settings.
     */
    func didFinishViewingSettings()
    
    /**
     Tells the delegate to show the buy tokens modal.
     */
    func showBuyTokensModal()
    
    /**
     Tells the delegate to change a specified setting.
     
     - parameter type: The type of setting to change.
     - parameter currentOption: The current value of the setting.
     */
    func changeSetting<E: RawRepresentable & CaseIterable>(_ type: E.Type, currentOption: E) where E.RawValue == String
    
    /**
     Tells the delegate to navigate to rate the application.
     */
    func rateApplication()
    
    /**
     Tells the delegate to show the specified page.
     
     - parameter page: The page to show.
     */
    func showPage(_ page: ExternalPage)
    
    /**
     Tells the delegate to sign out the user.
     */
    func signOut()
}
