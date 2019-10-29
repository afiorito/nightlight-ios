import UIKit

/// A coordinator for people flow.
public class PeopleCoordinator: TabBarCoordinator {
    public typealias Dependencies = StyleManaging
    public weak var parent: Coordinator?
    public var children = [Coordinator]()
    
    /// The required dependencies.
    private let dependencies: Dependencies

    /// The type of messages being shown.
    private let type: PeopleType
    
    /// The root view controller of the notifications view controller.
    public let rootViewController: UINavigationController
    
    /// The view model for managing the state of the view.
    private let viewModel: PeopleViewModel
    
    /// A view controller for displaying people.
    lazy var peopleViewController: PeopleViewController = {
        let viewController = PeopleViewController(viewModel: viewModel)
        viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage.icon.back, style: .plain, target: rootViewController, action: #selector(rootViewController.popViewController))
        
        viewModel.uiDelegate = viewController
        viewModel.navigationDelegate = self
        
        return viewController
    }()
    
    public init(type: PeopleType, rootViewController: UINavigationController, dependencies: Dependencies) {
        self.type = type
        self.rootViewController = rootViewController
        self.dependencies = dependencies
        
        self.viewModel = PeopleViewModel(dependencies: dependencies as! PeopleViewModel.Dependencies, type: type)
    }
    
    public func start() {
        rootViewController.pushViewController(peopleViewController, animated: true)
    }
    
}

// MARK: - People Navigation Delegate

extension PeopleCoordinator: PeopleNavigationDelegate {
    public func didFinishViewingPeople() {
        parent?.childDidFinish(self)
    }
}
