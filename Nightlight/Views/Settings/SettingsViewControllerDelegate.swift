public protocol SettingsViewControllerDelegate: class {
    func settingsViewControllerDidSelectTheme(_ settingsViewController: SettingsViewController, for currentTheme: Theme)
    func settingsViewControllerDidSelectDefaultMessage(_ settingsViewController: SettingsViewController, for currentMessageDefault: MessageDefault)
    func settingsViewControllerDidSelectFeedback(_ settingsViewController: SettingsViewController)
    func settingsViewControllerDidSelectRate(_ settingsViewController: SettingsViewController)
    func settingsViewControllerDidSelectAbout(_ settingsViewController: SettingsViewController)
    func settingsViewControllerDidSelectPrivacyPolicy(_ settingsViewController: SettingsViewController)
    func settingsViewControllerDidSelectTermsOfUse(_ settingsViewController: SettingsViewController)
    func settingsViewControllerDidSelectSignout(_ settingsViewController: SettingsViewController)
}
