import UIKit

/// A coordinator for notifications flow.
public class NotificationsCoordinator: TabBarCoordinator {
    public typealias Dependencies = StyleManaging
    public weak var parent: Coordinator?
    public var children = [Coordinator]()
    
    /// The required dependencies.
    private let dependencies: Dependencies

    /// The root view controller of the notifications view controller.
    public let rootViewController: UINavigationController
    
    /// a view controller for displaying notifications.
    lazy var notificationsViewController: NotificationsViewController = {
        let viewModel = UserNotificationsViewModel(dependencies: dependencies as! UserNotificationsViewModel.Dependencies)
        let viewController = NotificationsViewController(viewModel: viewModel)
        
        viewController.title = Strings.notification.notificationsTitle
        viewController.tabBarItem = UITabBarItem(title: Strings.notification.notificationsTitle, image: UIImage.tab.notification, tag: 0)
        viewController.emptyViewDescription = EmptyViewDescription.noNotifications
        
        return viewController
    }()
    
    init(rootViewController: UINavigationController, dependencies: Dependencies) {
        self.rootViewController = rootViewController
        self.dependencies = dependencies
    }
    
    public func start() {
        rootViewController.show(notificationsViewController, sender: rootViewController)
    }
    
}
