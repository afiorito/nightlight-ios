import UIKit

public class SearchCoordinator: TabBarCoordinator {
    public typealias Dependencies = StyleManaging

    public weak var parent: Coordinator?
    public var children = [Coordinator]()
    
    private let dependencies: Dependencies
    
    public lazy var rootViewController: UIViewController = {
        let viewModel = SearchViewModel(dependencies: dependencies as SearchViewModel.Dependencies)
        let searchViewController = SearchViewController(viewModel: viewModel)
        searchViewController.tabBarItem = UITabBarItem(title: "Search", image: UIImage(named: "tb_search"), tag: 0)
        
        return searchViewController
    }()

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    public func start() {}
    
}
