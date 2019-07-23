import Foundation

public class ProfileViewModel {
    public typealias Dependencies = PeopleServiced & StyleManaging
    
    private let dependencies: Dependencies
    
    public var theme: Theme {
        return dependencies.styleManager.theme
    }
    
    public init(dependencies: Dependencies) {
        self.dependencies = dependencies
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
