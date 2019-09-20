import UIKit

/// A coordinator for profile flow.
public class ProfileCoordinator: NSObject, TabBarCoordinator {
    public typealias Dependencies = KeychainManaging & StyleManaging
    public weak var parent: Coordinator?
    public var children = [Coordinator]()
    
    /// The required dependencies.
    private let dependencies: Dependencies

    /// The root view controller of the recent messages view controller.
    public let rootViewController: UINavigationController
    
    /// An array of view controllers for displaying messages.
    private lazy var messageViewControllers: [MessagesViewController] = {
        let messageDependencies = self.dependencies as! MessagesViewModel.Dependencies

        let types: [MessageType] = [.received, .sent, .saved]
        
        return types.map {
            let coordinator = MessagesCoordinator(type: $0, rootViewController: rootViewController, dependencies: dependencies)
            addChild(coordinator)
            
            return coordinator.messagesViewController
        }
    }()
    
    /// The view model for managing the state of the view.
    private lazy var viewModel: ProfileViewModel = {
        ProfileViewModel(dependencies: dependencies as! ProfileViewModel.Dependencies)
    }()
    
    /// A view controller for displaying a profile.
    lazy var profileViewController: ProfileViewController = {
        let viewController = ProfileViewController(viewModel: viewModel)
        
        viewController.tabBarItem = UITabBarItem(title: Strings.profile.profileTitle, image: UIImage.tab.profile, tag: 0)
        viewController.messageViewControllers = messageViewControllers
        
        viewModel.uiDelegate = viewController
        viewModel.navigationDelegate = self
        
        return viewController
    }()
    
    public init(rootViewController: UINavigationController, dependencies: Dependencies) {
        self.dependencies = dependencies
        self.rootViewController = rootViewController
    }
    
    public func start() {
        rootViewController.interactivePopGestureRecognizer?.delegate = self
        rootViewController.show(profileViewController, sender: rootViewController)
    }
}

// MARK: - Profile Navigation Delegate

extension ProfileCoordinator: ProfileNavigationDelegate {
    public func showSettings() {
        let coordinator = SettingsCoordinator(rootViewController: rootViewController, dependencies: self.dependencies as! SettingsCoordinator.Dependencies)
        addChild(coordinator)
        coordinator.start()
    }
}

extension ProfileCoordinator: UIGestureRecognizerDelegate {}
