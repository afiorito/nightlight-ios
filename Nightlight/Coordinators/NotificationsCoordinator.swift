import UIKit

public class NotificationsCoordinator: TabBarCoordinator {
    public typealias Dependencies = StyleManaging

    public weak var parent: Coordinator?
    public var children = [Coordinator]()
    
    private let dependencies: Dependencies

    public let rootViewController: UIViewController
    
    lazy var notificationsViewController: NotificationsViewController = {
        let viewModel = UserNotificationsViewModel(dependencies: dependencies as! UserNotificationsViewModel.Dependencies)
        let viewController = NotificationsViewController(viewModel: viewModel)

        guard let navController = rootViewController as? UINavigationController else {
            return viewController
        }
        
        viewController.navigationItem.titleView = {
            let navFrame = navController.navigationBar.frame
            let titleView = LabelTitleView(frame: CGRect(x: 15, y: 0,
                                                         width: navController.view.frame.width - 30,
                                                         height: navFrame.height))
            titleView.title = "Notifications"
            return titleView
        }()
        
        viewController.tabBarItem = UITabBarItem(title: "Notifications", image: UIImage(named: "tb_notification"), tag: 0)
        viewController.emptyViewDescription = EmptyViewDescription.noNotifications
        
        return viewController
    }()
    
    init(rootViewController: UIViewController, dependencies: Dependencies) {
        self.rootViewController = rootViewController
        self.dependencies = dependencies
    }
    
    public func start() {
        rootViewController.show(notificationsViewController, sender: rootViewController)
    }
    
}
