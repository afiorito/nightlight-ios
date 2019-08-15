import Foundation

/// A view model for handling people.
public class PeopleViewModel {
    public typealias Dependencies = PeopleServiced & StyleManaging
    
    /// The required dependencies.
    private let dependencies: Dependencies
    
    /// The active theme.
    public var theme: Theme {
        return dependencies.styleManager.theme
    }
    
    /// The current search filter for peole.
    public var filter: String = ""
    
    /// The start page for loading messages.
    private var startPage: String?
    
    /// The end page for loading messages.
    private var endPage: String?
    
    /// The total number of messages.
    private(set) var totalCount: Int = 0
    
    /// A boolean for determing if messages are already being fetched.
    private var isFetchInProgress = false
    
    public init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    /**
     Retrieve helpful people.
     
     - parameter result: the result of retrieving the helpful people.
     */
    public func getHelpfulPeople(result: @escaping (Result<[PersonViewModel], PersonError>) -> Void) {
        dependencies.peopleService.getHelpfulPeople { peopleResult in
            switch peopleResult {
            case .success(let people):
                let personViewModels = people.map { PersonViewModel(user: $0) }
                
                DispatchQueue.main.async { result(.success(personViewModels)) }
            case .failure(let error):
                DispatchQueue.main.async { result(.failure(error)) }
            }
        }
    }
    
    /**
     Retrieve people.
     
     - parameter result: the result of retrieving the people.
     */
    public func getPeople(result: @escaping (Result<[PersonViewModel], PersonError>) -> Void) {
        guard !isFetchInProgress && (endPage != nil || startPage == nil)
            else { return }
        
        isFetchInProgress = true
        
        dependencies.peopleService.getPeople(filter: filter, start: startPage, end: endPage) { peopleResult in
            self.isFetchInProgress = false

            switch peopleResult {
            case .success(let peopleResponse):
                self.startPage = peopleResponse.metadata.start
                self.endPage = peopleResponse.metadata.end
                self.totalCount = peopleResponse.metadata.total
                
                let personViewModels = peopleResponse.data.map { PersonViewModel(user: $0) }
                
                DispatchQueue.main.async { result(.success(personViewModels)) }
            case .failure(let error):
                DispatchQueue.main.async { result(.failure(error)) }
            }
        }
    }
    
    /**
     Resets the paging.
     
     Causes people to be fetched from the beginning.
     */
    public func resetPaging() {
        startPage = nil
        endPage = nil
    }
    
}
