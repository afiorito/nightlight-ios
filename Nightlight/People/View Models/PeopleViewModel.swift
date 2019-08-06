import Foundation

public class PeopleViewModel {
    
    public typealias Dependencies = PeopleServiced & StyleManaging
    
    private let dependencies: Dependencies
    
    public var theme: Theme {
        return dependencies.styleManager.theme
    }
    
    public var filter: String = ""
    
    private var startPage: String?
    private var endPage: String?
    
    private(set) var totalCount: Int = 0
    
    private var isFetchInProgress = false
    
    public init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
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
    
    public func resetPaging() {
        startPage = nil
        endPage = nil
    }
    
}
