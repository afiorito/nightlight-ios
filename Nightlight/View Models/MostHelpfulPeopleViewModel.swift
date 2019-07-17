import Foundation

public class MostHelpfulPeopleViewModel {
    
    public typealias Dependencies = MessageServiced & StyleManaging
    
    private let dependencies: Dependencies
    
    public var theme: Theme {
        return dependencies.styleManager.theme
    }
    
    private var startPage: String?
    private var endPage: String?
    
    private(set) var totalCount: Int = 0
    
    private var isFetchInProgress = false
    
    public init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
}
