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
        viewController.emptyViewDescription = EmptyViewDescription.noRecentMessages
        
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
    
    public func messagesViewController(_ messagesViewController: MessagesViewController, moreContextFor message: MessageViewModel) {
        let contextMenuViewController = ContextMenuViewController()
        
        contextMenuViewController.addOption(ContextOption.reportOption({ _ in
            messagesViewController.dismiss(animated: true) {
                messagesViewController.showToast("The message has been reported!", severity: .success)
            }
        }))

        contextMenuViewController.modalPresentationStyle = .custom
        contextMenuViewController.modalPresentationCapturesStatusBarAppearance = true
        contextMenuViewController.transitioningDelegate = BottomSheetTransitioningDelegate.default
        
        messagesViewController.present(contextMenuViewController, animated: true)
    }
    
}

extension RecentMessagesCoordinator: MessageDetailViewControllerDelegate {
    public func messageDetailViewController(_ messageDetailViewController: MessageDetailViewController, didUpdate message: MessageViewModel) {
        recentMessagesViewController.reloadSelectedIndexPath(with: message)
    }
    
}
