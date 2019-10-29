import Foundation

/// A view model for handling people.
public class PeopleViewModel {
    public typealias Dependencies = PeopleServiced & StyleManaging
    
    /// The required dependencies.
    private let dependencies: Dependencies
    
    /// The delegate object that handles user interface updates.
    public weak var uiDelegate: PeopleViewModelUIDelegate?
    
    /// The delegate object that handles navigation events.
    public weak var navigationDelegate: PeopleNavigationDelegate?
    
    /// The fetched people.
    private var people = [User]()
    
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
    
    private let type: PeopleType
    
    public init(dependencies: Dependencies, type: PeopleType) {
        self.dependencies = dependencies
        self.type = type
    }
    
    /**
     Retrieve people.
     
     - parameter fromStart: A boolean denoting if the data is being fetched from the beginning of a paginated list.
     */
    public func fetchPeople(fromStart: Bool) {
        if fromStart { resetPaging() }

        guard !isFetchInProgress && (endPage != nil || startPage == nil)
            else { return }
        
        isFetchInProgress = true
        uiDelegate?.didBeginFetchingPeople(fromStart: fromStart)
        
        dependencies.peopleService.getPeople(endpoint: endpoint) { [weak self] peopleResult in
            guard let self = self else { return }

            self.isFetchInProgress = false
            DispatchQueue.main.async { self.uiDelegate?.didEndFetchingPeople() }

            switch peopleResult {
            case .success(let peopleResponse):
                self.startPage = peopleResponse.metadata.start
                self.endPage = peopleResponse.metadata.end
                self.totalCount = peopleResponse.metadata.total
                
                self.people = fromStart ? peopleResponse.data : self.people + peopleResponse.data
                
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.uiDelegate?.didFetchPeople(with: peopleResponse.data.count, fromStart: fromStart)
                    switch self.type {
                    case .love: self.uiDelegate?.updateTitle("\(self.totalCount) love")
                    case .appreciation: self.uiDelegate?.updateTitle("\(self.totalCount) appreciation")
                    default: break
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async { self.uiDelegate?.didFailToFetchPeople(with: error) }
            }
        }
    }
    
    /**
     Returns a person as a `PersonViewModel` at a specified indexPath.
     
     - parameter indexPath: The index path for the person.
     */
    public func personViewModel(at indexPath: IndexPath) -> PersonViewModel {
        return PersonViewModel(user: people[indexPath.row])
    }
    
    /**
     Stop viewing people.
     */
    public func finish() {
        navigationDelegate?.didFinishViewingPeople()
    }
    
    /**
     Resets the paging.
     
     Causes people to be fetched from the beginning.
     */
    public func resetPaging() {
        startPage = nil
        endPage = nil
    }
    
    private var endpoint: Endpoint {
        switch type {
        case .default: return Endpoint.user(filter: filter, start: startPage, end: endPage)
        case .love(let id): return Endpoint.love(for: id, start: startPage, end: endPage)
        case .appreciation(let id): return Endpoint.appreciation(for: id, start: startPage, end: endPage)
        }
    }
    
}
