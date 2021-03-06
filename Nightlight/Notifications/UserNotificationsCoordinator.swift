import UIKit

/// A coordinator for notifications flow.
public class UserNotificationsCoordinator: TabBarCoordinator {
    public typealias Dependencies = StyleManaging
    public weak var parent: Coordinator?
    public var children = [Coordinator]()
    
    /// The required dependencies.
    private let dependencies: Dependencies

    /// The root view controller of the notifications view controller.
    public let rootViewController: UINavigationController
    
    /// The view model for managing the state of the view.
    private lazy var viewModel: UserNotificationsViewModel = {
        UserNotificationsViewModel(dependencies: dependencies as! UserNotificationsViewModel.Dependencies)
    }()
    
    /// A view controller for displaying notifications.
    lazy var notificationsViewController: NotificationsViewController = {
        let viewController = NotificationsViewController(viewModel: viewModel)
        
        viewController.title = Strings.notification.notificationsTitle
        viewController.tabBarItem = UITabBarItem(title: Strings.notification.notificationsTitle, image: UIImage.tab.notification, tag: 0)
        viewController.emptyViewDescription = EmptyViewDescription.noNotifications
        
        viewModel.uiDelegate = viewController
        viewModel.navigationDelegate = self
        
        return viewController
    }()
    
    public init(rootViewController: UINavigationController, dependencies: Dependencies) {
        self.rootViewController = rootViewController
        self.dependencies = dependencies
    }
    
    public func start() {
        rootViewController.show(notificationsViewController, sender: rootViewController)
    }
    
}

extension UserNotificationsCoordinator: UserNotificationsNavigationDelegate {
    public func showMessageDetail(with id: Int) {
        let coordinator = MessageDetailCoordinator(messageId: id, rootViewController: rootViewController, dependencies: dependencies)
        addChild(coordinator)
        coordinator.start()
    }
    
    public func showMessageLove(for id: Int) {
        let coordinator = PeopleCoordinator(type: .love(id), rootViewController: rootViewController, dependencies: dependencies)
        addChild(coordinator)
        coordinator.start()
    }
    
    public func showMessageAppreciation(for id: Int) {
        let coordinator = PeopleCoordinator(type: .appreciation(id), rootViewController: rootViewController, dependencies: dependencies)
        addChild(coordinator)
        coordinator.start()
    }
    
}
