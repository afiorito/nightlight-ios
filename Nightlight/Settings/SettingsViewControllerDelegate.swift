/// Methods for handling UI actions occurring in a settings view controller.
public protocol SettingsViewControllerDelegate: class {
    /**
     Tells the delegate that the appreciation setting is selected.
     
     - parameter settingsViewController: a settings view controller object informing about the appreciation setting being selected.
     */
    func settingsViewControllerDidSelectAppreciation(_ settingsViewController: SettingsViewController)
    
    /**
     Tells the delegate that the theme setting is selected.
     
     - parameter settingsViewController: a settings view controller object informing about the theme setting being selected.
     - parameter currentTheme: the theme selected for the theme setting.
     */
    func settingsViewControllerDidSelectTheme(_ settingsViewController: SettingsViewController, for currentTheme: Theme)
    
    /**
     Tells the delegate that the message default setting is selected.
     
     - parameter settingsViewController: a settings view controller object informing about the message default setting being selected.
     - parameter currentMessageDefault: the message default selected for the message default setting.
     */
    func settingsViewControllerDidSelectDefaultMessage(_ settingsViewController: SettingsViewController, for currentMessageDefault: MessageDefault)
    
    /**
     Tells the delegate that the feedback setting is selected.
     
     - parameter settingsViewController: a settings view controller object informing about the feedback setting being selected.
     */
    func settingsViewControllerDidSelectFeedback(_ settingsViewController: SettingsViewController)
    
    /**
     Tells the delegate that the rate setting is selected.
     
     - parameter settingsViewController: a settings view controller object informing about the rate setting being selected.
     */
    func settingsViewControllerDidSelectRate(_ settingsViewController: SettingsViewController)
    
    /**
     Tells the delegate that the about setting is selected.
     
     - parameter settingsViewController: a settings view controller object informing about the about setting being selected.
     */
    func settingsViewControllerDidSelectAbout(_ settingsViewController: SettingsViewController)
    
    /**
     Tells the delegate that the privacy policy setting is selected.
     
     - parameter settingsViewController: a settings view controller object informing about the privacy policy setting being selected.
     */
    func settingsViewControllerDidSelectPrivacyPolicy(_ settingsViewController: SettingsViewController)
    
    /**
     Tells the delegate that the terms of use setting is selected.
     
     - parameter settingsViewController: a settings view controller object informing about the terms of use setting being selected.
     */
    func settingsViewControllerDidSelectTermsOfUse(_ settingsViewController: SettingsViewController)
    
    /**
     Tells the delegate that the sign out option is selected.
     
     - parameter settingsViewController: a settings view controller object informing about the sign out option being selected.
     */
    func settingsViewControllerDidSelectSignout(_ settingsViewController: SettingsViewController)
}
