import Foundation

/// A view model for handling account settings.
public class AccountSettingsViewModel {
    public typealias Dependencies = PeopleServiced & KeychainManaging & StyleManaging
    
    /// The required dependencies.
    private let dependencies: Dependencies
    
    /// The delegate object that handles user interface updates.
    public weak var uiDelegate: AccountSettingsViewModelUIDelegate?
    
    /// The delegate object that handles navigation events.
    public weak var navigationDelegate: AccountSettingsNavigationDelegate?
    
    /// The delegate object that handles change account detail events.
    public weak var eventDelegate: ChangeAccountDetailEventDelegate?
    
    /// The active theme.
    public var theme: Theme {
        return dependencies.styleManager.theme
    }

    /// The email of the user.
    public var email: String {
        let email = try? dependencies.keychainManager.string(for: KeychainKey.email.rawValue)
        return email ?? ""
    }
    
    public init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    /**
     Load the user account.
     
     - parameter result: the result of loading the user account.
     */
    public func loadAccount() {
        dependencies.peopleService.getPerson { [weak self] personResult in
            switch personResult {
            case .success:
                DispatchQueue.main.async { self?.uiDelegate?.didFetchAccount() }
            case .failure(let error):
                DispatchQueue.main.async { self?.uiDelegate?.didFailToFetchAccount(with: error) }
            }
        }
    }
    
    /**
     Show the change email view.
     */
    public func selectEmail() {
        navigationDelegate?.showChangeEmail()
    }
    
    /**
     Show the change password view.
     */
    public func selectPassword() {
        navigationDelegate?.showChangePassword()
    }
    
    /**
     Change the user's email
     
     - parameter email: The new email of the user.
     */
    public func changeEmail(_ email: String) {
        eventDelegate?.didBeginChange()

        dependencies.peopleService.changeEmail(email) { (changeEmailResult) in
            switch changeEmailResult {
            case .success:
                DispatchQueue.main.async { [weak self] in
                    self?.eventDelegate?.didChange()
                    self?.uiDelegate?.didChangeEmail()
                    self?.navigationDelegate?.didChangeEmail()
                }
            case .failure(let error):
                DispatchQueue.main.async { [weak self] in
                    if case .validation = error {
                        self?.eventDelegate?.didFailChange(with: error)
                    } else {
                        self?.uiDelegate?.didFailChangeEmail(with: error)
                        self?.navigationDelegate?.didFailChangeEmail()
                    }
                }
            }
            
            DispatchQueue.main.async { [weak self] in self?.eventDelegate?.didEndChange() }
        }
    }
    
    /**
     Change the user's password
     
     - parameter password: The current password of the user.
     - parameter newPassword: The new password of the user.
     */
    public func changePassword(_ password: String, newPassword: String) {
        eventDelegate?.didBeginChange()

        dependencies.peopleService.changePassword(password, newPassword: newPassword) { (changePasswordResult) in
            switch changePasswordResult {
            case .success:
                DispatchQueue.main.async { [weak self] in
                    self?.eventDelegate?.didChange()
                    self?.uiDelegate?.didChangePassword()
                    self?.navigationDelegate?.didChangePassword()
                }
            case .failure(let error):
                DispatchQueue.main.async { [weak self] in
                    if case .validation = error {
                        self?.eventDelegate?.didFailChange(with: error)
                    } else {
                        self?.uiDelegate?.didFailChangePassword(with: error)
                        self?.navigationDelegate?.didFailChangePassword()
                    }
                }
            }
            
            DispatchQueue.main.async { [weak self] in self?.eventDelegate?.didEndChange() }
        }
    }
    
    /**
     Stop viewing account settings.
     */
    public func finish() {
        navigationDelegate?.didFinishViewingAccountSettings()
    }
    
}
