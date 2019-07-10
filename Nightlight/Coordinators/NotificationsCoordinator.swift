import UIKit

public class NotificationsCoordinator: TabBarCoordinator {
    public typealias Dependencies = StyleManaging

    public weak var parent: Coordinator?
    public var children = [Coordinator]()
    
    private let dependencies: Dependencies

    public let rootViewController: UIViewController
    
    init(rootViewController: UIViewController, dependencies: Dependencies) {
        self.rootViewController = rootViewController
        self.dependencies = dependencies
    }
    
    public func start() {
        let viewModel = NotificationsViewModel(dependencies: dependencies as NotificationsViewModel.Dependencies)
        let notificationsViewController = NotificationsViewController(viewModel: viewModel)
        notificationsViewController.title = "Notifications"
        notificationsViewController.tabBarItem = UITabBarItem(title: "Notifications", image: UIImage(named: "tb_notification"), tag: 0)
        rootViewController.show(notificationsViewController, sender: rootViewController)
    }
    
}
