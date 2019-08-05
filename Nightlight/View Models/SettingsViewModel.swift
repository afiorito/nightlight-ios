import Foundation

public class SettingsViewModel {
    public typealias Dependencies = UserDefaultsManaging & KeychainManaging & StyleManaging
    
    private let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    var tokens: Int {
        let tokens = try? dependencies.keychainManager.integer(forKey: KeychainKey.tokens.rawValue)
        return tokens ?? 0
    }
    
    var theme: Theme {
        return dependencies.styleManager.theme
    }
    
    var messageDefault: MessageDefault {
        return dependencies.userDefaultsManager.messageDefault
    }
    
    public func updateTheme(_ theme: Theme) {
        dependencies.userDefaultsManager.theme = theme
        dependencies.styleManager.theme = theme
    }
    
    public func updateMessageDefault(_ default: MessageDefault) {
        dependencies.userDefaultsManager.messageDefault = `default`
    }
    
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
