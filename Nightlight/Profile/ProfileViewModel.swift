import Foundation

public class ProfileViewModel {
    public typealias Dependencies = PeopleServiced & KeychainManaging & StyleManaging
    
    private let dependencies: Dependencies
    
    public var theme: Theme {
        return dependencies.styleManager.theme
    }
    
    public init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    var username: String {
        let username = try? dependencies.keychainManager.string(forKey: KeychainKey.username.rawValue)
        return username ?? "-"
    }
    
    var dateSince: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM YYYY"
        
        if let createdAt = (try? dependencies.keychainManager.double(forKey: KeychainKey.userCreatedAt.rawValue)) {
            return "Helping since \(formatter.string(from: Date(timeIntervalSince1970: createdAt)))"
        }
        
        return "Helping since -"
    }
    
    public func getProfile(result: @escaping (Result<PersonViewModel, PersonError>) -> Void) {
        dependencies.peopleService.getPerson { profileResult in
            switch profileResult {
            case .success(let person):
                DispatchQueue.main.async { result(.success(PersonViewModel(user: person))) }
            case .failure(let error):
                DispatchQueue.main.async {
                    result(.failure(error))
                }
            }
        }
    }
}
