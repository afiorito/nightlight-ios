import Foundation

/// A view model for handling a profile.
public class ProfileViewModel {
    public typealias Dependencies = PeopleServiced & KeychainManaging & StyleManaging
    
    /// The required dependencies.
    private let dependencies: Dependencies
    
    /// The active theme.
    public var theme: Theme {
        return dependencies.styleManager.theme
    }
    
    public init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    /// The username of a person.
    var username: String {
        let username = try? dependencies.keychainManager.string(for: KeychainKey.username.rawValue)
        return username ?? "-"
    }
    
    /// The date a person joined.
    var dateSince: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM YYYY"
        
        if let createdAt = (try? dependencies.keychainManager.double(for: KeychainKey.userCreatedAt.rawValue)) {
            return "\(Strings.profile.helpingSince) \(formatter.string(from: Date(timeIntervalSince1970: createdAt)))"
        }
        
        return "\(Strings.profile.helpingSince) -"
    }
    
    /**
     Retrieve profile information.
     
     - parameter result: the result of retrieving profile information.
     */
    public func getProfile(result: @escaping (Result<PersonViewModel, PersonError>) -> Void) {
        dependencies.peopleService.getPerson { profileResult in
            switch profileResult {
            case .success(let person):
                DispatchQueue.main.async { result(.success(PersonViewModel(user: person))) }
            case .failure(let error):
                DispatchQueue.main.async { result(.failure(error)) }
            }
        }
    }
}
