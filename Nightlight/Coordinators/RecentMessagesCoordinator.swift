import UIKit

public class RecentMessagesCoordinator: TabBarCoordinator {
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
        let viewModel = RecentMessagesViewModel(dependencies: dependencies as RecentMessagesViewModel.Dependencies)
        let recentMessagesViewController = RecentMessagesViewController(viewModel: viewModel)
        recentMessagesViewController.title = "Recent Messages"
        recentMessagesViewController.tabBarItem = UITabBarItem(title: "Recent", image: UIImage(named: "tb_recent"), tag: 0)
        rootViewController.show(recentMessagesViewController, sender: rootViewController)
    }
    
}
