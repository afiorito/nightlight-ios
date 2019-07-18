import UIKit

public class SearchCoordinator: TabBarCoordinator {
    public typealias Dependencies = StyleManaging

    public weak var parent: Coordinator?
    public var children = [Coordinator]()
    
    private let dependencies: Dependencies
    
    public let rootViewController: UIViewController
    
    public lazy var searchViewController: SearchViewController = {
        let peopleViewModel = PeopleViewModel(dependencies: dependencies as! PeopleViewModel.Dependencies)
        let helpfulPeopleViewModel = PeopleViewModel(dependencies: dependencies as! PeopleViewModel.Dependencies)
        
        let helpfulPeopleViewController = HelpfulPeopleViewController(viewModel: helpfulPeopleViewModel)
        let peopleViewController = PeopleViewController(viewModel: peopleViewModel)
        peopleViewController.emptyViewDescription = EmptyViewDescription.noResults
        
        let viewController = SearchViewController(baseViewController: helpfulPeopleViewController, searchResultsController: peopleViewController)
        
        viewController.tabBarItem = UITabBarItem(title: "Search", image: UIImage(named: "tb_search"), tag: 0)
        
        return viewController
    }()

    init(rootViewController: UIViewController, dependencies: Dependencies) {
        self.rootViewController = rootViewController
        self.dependencies = dependencies
    }
    
    public func start() {
        rootViewController.show(searchViewController, sender: rootViewController)
    }
    
}
