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
        
        viewController.navigationItem.titleView = {
            let navFrame = rootViewController.navigationBar.frame
            let titleView = LabelTitleView(frame: CGRect(x: 15, y: 0,
                                                         width: rootViewController.view.frame.width - 30,
                                                         height: navFrame.height))
            titleView.title = Strings.notification.notificationsTitle
            return titleView
        }()
        
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
