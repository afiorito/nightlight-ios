import Foundation

/// A view model for handling a profile.
public class ProfileViewModel {
    public typealias Dependencies = PeopleServiced & KeychainManaging & StyleManaging
    
    /// The required dependencies.
    private let dependencies: Dependencies
    
    /// The delegate object that handles user interface updates.
    public weak var uiDelegate: ProfileViewModelUIDelegate?
    
    /// The delegate object that handles navigation events.
    public weak var navigationDelegate: ProfileNavigationDelegate?
    
    /// The backing user model.
    private var person: User?
    
    /// The representation of a person as a person view model.
    private var personViewModel: PersonViewModel? {
        guard let person = person else { return nil }
        return PersonViewModel(user: person)
    }
    
    /// The active theme.
    public var theme: Theme {
        return dependencies.styleManager.theme
    }
    
    public init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    /// The username of a person.
    var username: String {
        guard let personViewModel = personViewModel else {
            return (try? dependencies.keychainManager.string(for: KeychainKey.username.rawValue)) ?? "-"
        }
        
        return personViewModel.username
    }
    
    /// The date a person joined.
    var helpingSince: String {
        guard let personViewModel = personViewModel else {
            if let createdAt = (try? dependencies.keychainManager.double(for: KeychainKey.userCreatedAt.rawValue)) {
                let helpingSince = PersonViewModel.formatter.string(from: Date(timeIntervalSince1970: createdAt))
                return "\(Strings.profile.helpingSince) \(helpingSince)"
            }
            
            return "\(Strings.profile.helpingSince) -"
        }
        
        return personViewModel.helpingSince
    }
    
    /// The total love a person has received.
    var totalLove: Int {
        if let totalLove = personViewModel?.totalLove {
            return totalLove
        }
        
        return (try? dependencies.keychainManager.integer(for: KeychainKey.totalLove.rawValue)) ?? 0
    }
    
    /// The total appreciation a person has received.
    var totalAppreciation: Int {
        if let totalAppreciation = personViewModel?.totalAppreciation {
            return totalAppreciation
        }
        
        return (try? dependencies.keychainManager.integer(for: KeychainKey.totalAppreciation.rawValue)) ?? 0
    }
    
    /**
     Retrieve profile information.
     */
    public func fetchProfile() {
        uiDelegate?.didBeginFetchingProfile()
        
        dependencies.peopleService.getPerson { [weak self] profileResult in
            DispatchQueue.main.async { self?.uiDelegate?.didEndFetchingProfile() }
            
            switch profileResult {
            case .success(let person):
                self?.person = person
                DispatchQueue.main.async { self?.uiDelegate?.didFetchProfile() }
            case .failure(let error):
                DispatchQueue.main.async { self?.uiDelegate?.didFailToFetchProfile(with: error) }
            }
        }
    }
    
    /**
     Show the application settings.
     */
    public func showSettings() {
        navigationDelegate?.showSettings()
    }
}
