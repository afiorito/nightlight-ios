import UIKit

public class RecentMessagesCoordinator: NSObject, TabBarCoordinator {
    public typealias Dependencies = StyleManaging

    public weak var parent: Coordinator?
    public var children = [Coordinator]()
    
    private let dependencies: Dependencies
    
    public let rootViewController: UIViewController
    
    lazy var recentMessagesViewController: MessagesViewController = {
        let title = "Recent Messages"
        let viewModel = MessagesViewModel(dependencies: dependencies as! MessagesViewModel.Dependencies, type: .recent)
        
        let viewController = MessagesViewController(viewModel: viewModel)
        viewController.delegate = self
        viewController.title = title
        viewController.navigationItem.backBarButtonItem = UIBarButtonItem(title: title, style: .plain, target: self, action: nil)
        viewController.tabBarItem = UITabBarItem(title: "Recent", image: UIImage(named: "tb_recent"), tag: 0)
        
        let description = EmptyViewDescription(title: "No Recent Messages", subtitle: "Tap the + to send one", imageName: "empty_message")
        viewController.emptyViewDescription = description
        
        return viewController
    }()
    
    init(rootViewController: UIViewController, dependencies: Dependencies) {
        self.rootViewController = rootViewController
        self.dependencies = dependencies
    }
    
    public func start() {
        
        rootViewController.show(recentMessagesViewController, sender: rootViewController)
    }
    
}

extension RecentMessagesCoordinator: MessagesViewControllerDelegate {
    public func messagesViewController(_ messagesViewController: MessagesViewController, didSelect message: MessageViewModel) {
        let messageDetailViewController = MessageDetailViewController(viewModel: message)
        messageDetailViewController.delegate = self
        rootViewController.show(messageDetailViewController, sender: rootViewController)
    }
    
}

extension RecentMessagesCoordinator: MessageDetailViewControllerDelegate {
    public func messageDetailViewController(_ messageDetailViewController: MessageDetailViewController, didUpdate message: MessageViewModel) {
        recentMessagesViewController.reloadSelectedIndexPath(with: message)
    }
    
}
