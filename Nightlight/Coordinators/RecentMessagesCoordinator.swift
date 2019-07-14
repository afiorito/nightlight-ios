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
        let viewModel = MessagesViewModel(dependencies: dependencies as! MessagesViewModel.Dependencies, type: .recent)
        let recentMessagesViewController = MessagesViewController(viewModel: viewModel)
        recentMessagesViewController.title = "Recent Messages"
        recentMessagesViewController.tabBarItem = UITabBarItem(title: "Recent", image: UIImage(named: "tb_recent"), tag: 0)
        let description = EmptyViewDescription(title: "No Recent Messages", subtitle: "Tap the + to send one", imageName: "empty_message")
        recentMessagesViewController.emptyViewDescription = description
        rootViewController.show(recentMessagesViewController, sender: rootViewController)
    }
    
}
