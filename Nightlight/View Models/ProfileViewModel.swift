public class ProfileViewModel {
    public typealias Dependencies = StyleManaging
    
    private let dependencies: Dependencies
    
    public var theme: Theme {
        return dependencies.styleManager.theme
    }
    
    public init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
}
