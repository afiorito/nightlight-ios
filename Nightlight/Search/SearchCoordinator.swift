import UIKit

/// A coordinator for search flow.
public class SearchCoordinator: TabBarCoordinator {
    public typealias Dependencies = StyleManaging
    public weak var parent: Coordinator?
    public var children = [Coordinator]()
    
    /// The required depedencies.
    private let dependencies: Dependencies
    
    /// The root view controller of the search view controller.
    public let rootViewController: UINavigationController
    
    /// A view controller for displaying search results.
    public lazy var searchViewController: SearchViewController = {
        let peopleViewModel = PeopleViewModel(dependencies: dependencies as! PeopleViewModel.Dependencies)
        let helpfulPeopleViewModel = HelpfulPeopleViewModel(dependencies: dependencies as! PeopleViewModel.Dependencies)
        
        let helpfulPeopleViewController = HelpfulPeopleViewController(viewModel: helpfulPeopleViewModel)
        let peopleViewController = PeopleViewController(viewModel: peopleViewModel)
        peopleViewController.emptyViewDescription = EmptyViewDescription.noResults
        
        let viewController = SearchViewController(baseViewController: helpfulPeopleViewController, searchResultsController: peopleViewController)
        
        viewController.tabBarItem = UITabBarItem(title: Strings.search.searchTitle, image: UIImage.tab.search, tag: 0)
        
        peopleViewModel.uiDelegate = peopleViewController
        helpfulPeopleViewModel.uiDelegate = helpfulPeopleViewController
        
        return viewController
    }()

    public init(rootViewController: UINavigationController, dependencies: Dependencies) {
        self.rootViewController = rootViewController
        self.dependencies = dependencies
    }
    
    public func start() {
        rootViewController.show(searchViewController, sender: rootViewController)
    }
    
}
