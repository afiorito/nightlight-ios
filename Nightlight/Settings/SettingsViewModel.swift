import Foundation

/// A view model for handling settings.
public class SettingsViewModel {
    public typealias Dependencies = UserDefaultsManaging & KeychainManaging & StyleManaging
    
    /// The required dependencies.
    private let dependencies: Dependencies
    
    /// The delegate object that handles user interface updates.
    public weak var uiDelegate: SettingsViewModelUIDelegate?
    
    /// The delegate object that handles navigation events.
    public weak var navigationDelegate: SettingsNavigationDelegate?
    
    /// The active theme.
    public var theme: Theme {
        return dependencies.styleManager.theme
    }

    /// The number of tokens a person has.
    public var tokens: Int {
        let tokens = try? dependencies.keychainManager.integer(for: KeychainKey.tokens.rawValue)
        return tokens ?? 0
    }
    
    /// The current value of the send message default setting.
    public var messageDefault: MessageDefault {
        return dependencies.userDefaultsManager.messageDefault
    }
    
    /// The total number of ratings for the current version.
    public var userRatingCountForCurrentVersion = 0
    
    /// A boolean for indicating if the tokens are in the loading state.
    public var isTokensLoading = false
    
    public init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    /**
     Update the application theme.
     
     - parameter theme: the new theme to update to.
     */
    public func updateTheme(_ theme: Theme) {
        dependencies.userDefaultsManager.theme = theme
        dependencies.styleManager.theme = theme
    }
    
    /**
     Update the message default setting.
     
     - parameter default: the new message default to update to.
     */
    public func updateMessageDefault(_ default: MessageDefault) {
        dependencies.userDefaultsManager.messageDefault = `default`
        uiDelegate?.updateView()
    }
    
    /**
     Load the app ratings for this version.
     
     - parameter result: the result of loading the app ratings.
     */
    public func loadRatings() {
        HttpClient().get(endpoint: Endpoint.itunesRatingCount) { [weak self] networkResult in
            switch networkResult {
            case .success(_, let data):
                do {
                    let itunesSearchBody: iTunesSearchBody = try data.decodeJSON()
                    self?.userRatingCountForCurrentVersion = itunesSearchBody.results.first?.userRatingCountForCurrentVersion ?? 0
                    DispatchQueue.main.async { self?.uiDelegate?.didFetchRatings() }
                } catch let error {
                    DispatchQueue.main.async { self?.uiDelegate?.didFailToFetchRatings(with: error) }
                }
            case .failure(let error):
                DispatchQueue.main.async { self?.uiDelegate?.didFailToFetchRatings(with: error) }
            }
        }
    }
    
    /**
     Purchase more tokens.
     */
    public func buyTokens() {
        isTokensLoading = true
        uiDelegate?.updateTokens()
        navigationDelegate?.showBuyTokensModal()
    }
    
    /**
     Change the theme setting of the application.
     */
    public func changeTheme() {
        navigationDelegate?.changeSetting(Theme.self, currentOption: theme)
    }
    
    /**
     Change the message default setting of the application.
     */
    public func changeMessageDefault() {
        navigationDelegate?.changeSetting(MessageDefault.self, currentOption: messageDefault)
    }
    
    /**
     Show the feedback view.
     */
    public func selectFeedback() {
        navigationDelegate?.showPage(.feedback)
    }
    
    /**
     Allow a user to rate the application.
     */
    public func selectRating() {
        navigationDelegate?.rateApplication()
    }
    
    /**
     Show the about view.
     */
    public func selectAbout() {
        navigationDelegate?.showPage(.about)
    }
    
    /**
     Show the privacy policy view.
     */
    public func selectPrivacyPolicy() {
        navigationDelegate?.showPage(.privacy)
    }
    
    /**
     Show the terms of use view.
     */
    public func selectTermsOfUse() {
        navigationDelegate?.showPage(.terms)
    }
    
    /**
     Sign out the user.
     */
    public func signOut() {
        navigationDelegate?.signOut()
    }
    
    /**
     Stop viewing the settings.
     */
    public func finish() {
        navigationDelegate?.didFinishViewingSettings()
    }
}

// MARK: - Navigation Events

extension SettingsViewModel {
    public func didCompletePurchase() {
        isTokensLoading = false
        uiDelegate?.didCompletePurchase()
    }
        
    public func didFailPurchase() {
        isTokensLoading = false
        uiDelegate?.didFailPurchase()
    }
    
    public func didCancelPurchase() {
        isTokensLoading = false
        uiDelegate?.didCompletePurchase()
    }
}
