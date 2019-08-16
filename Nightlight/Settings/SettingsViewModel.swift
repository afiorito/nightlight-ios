import Foundation

/// A view model for handling settings.
public class SettingsViewModel {
    public typealias Dependencies = UserDefaultsManaging & KeychainManaging & StyleManaging
    
    /// The required dependencies.
    private let dependencies: Dependencies
    
    /// The active theme.
    var theme: Theme {
        return dependencies.styleManager.theme
    }

    /// The number of tokens a person has.
    var tokens: Int {
        let tokens = try? dependencies.keychainManager.integer(forKey: KeychainKey.tokens.rawValue)
        return tokens ?? 0
    }
    
    /// The current value of the send message default setting.
    var messageDefault: MessageDefault {
        return dependencies.userDefaultsManager.messageDefault
    }
    
    init(dependencies: Dependencies) {
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
    }
    
    /**
     Load the app ratings for this version.
     
     - parameter result: the result of loading the app ratings.
     */
    public func loadRatings(result: @escaping (Result<Int, Error>) -> Void) {
        HttpClient().get(endpoint: Endpoint.itunesRatingCount) { networkResult in
            switch networkResult {
            case .success(_, let data):
                do {
                    let itunesSearchBody: iTunesSearchBody = try data.decodeJSON()
                    DispatchQueue.main.async { result(.success(itunesSearchBody.userRatingCountForCurrentVersion ?? 0)) }
                    
                } catch let error {
                    DispatchQueue.main.async { result(.failure(error)) }
                }
            case .failure(let error):
                DispatchQueue.main.async { result(.failure(error)) }
            }
        }
    }
}
