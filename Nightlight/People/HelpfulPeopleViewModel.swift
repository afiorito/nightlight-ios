import Foundation

/// A view model for handling people.
public class HelpfulPeopleViewModel {
    public typealias Dependencies = PeopleServiced & StyleManaging
    
    /// The required dependencies.
    private let dependencies: Dependencies
    
    /// The delegate object that handles user interface updates.
    public weak var uiDelegate: HelpfulPeopleViewModelUIDelegate?
    
    /// The fetched people.
    private var people = [User]()
    
    /// The active theme.
    public var theme: Theme {
        return dependencies.styleManager.theme
    }

    public init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    /**
     Retrieve helpful people.
     */
    public func fetchHelpfulPeople() {
        uiDelegate?.didBeginFetchingHelpfulPeople()

        dependencies.peopleService.getHelpfulPeople { [weak self] peopleResult in
            switch peopleResult {
            case .success(let people):
                self?.people = people
                
                DispatchQueue.main.async { self?.uiDelegate?.didFetchHelpfulPeople(with: people.count) }
            case .failure(let error):
                DispatchQueue.main.async { self?.uiDelegate?.didFailToFetchHelpfulPeople(with: error) }
            }
            
            DispatchQueue.main.async { self?.uiDelegate?.didEndFetchingHelpfulPeople() }
        }
    }
    
    /**
     Returns a person as a `PersonViewModel` at a specified indexPath.
     
     - parameter indexPath: The index path for the person.
     */
    public func personViewModel(at indexPath: IndexPath) -> PersonViewModel {
        return PersonViewModel(user: people[indexPath.row])
    }
}
