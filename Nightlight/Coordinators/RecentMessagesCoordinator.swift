import UIKit

public class RecentMessagesCoordinator: NSObject, TabBarCoordinator {
    public typealias Dependencies = StyleManaging

    public weak var parent: Coordinator?
    public var children = [Coordinator]()
    
    private let dependencies: Dependencies
    
    public let rootViewController: UINavigationController
    
    lazy var recentMessagesViewController: MessagesViewController = {
        let viewModel = MessagesViewModel(dependencies: dependencies as! MessagesViewModel.Dependencies, type: .recent)
        let viewController = MessagesViewController(viewModel: viewModel)

        let title = "Recent Messages"
        
        viewController.delegate = self
        viewController.navigationItem.titleView = {
            let navFrame = rootViewController.navigationBar.frame
            let titleView = LabelTitleView(frame: CGRect(x: 15, y: 0,
                                                         width: rootViewController.view.frame.width - 30,
                                                         height: navFrame.height))
            titleView.title = title
            return titleView
        }()
        
        viewController.navigationItem.backBarButtonItem = UIBarButtonItem(title: title, style: .plain, target: self, action: nil)
        viewController.tabBarItem = UITabBarItem(title: "Recent", image: UIImage(named: "tb_recent"), tag: 0)
        viewController.emptyViewDescription = EmptyViewDescription.noRecentMessages
        
        return viewController
    }()
    
    init(rootViewController: UINavigationController, dependencies: Dependencies) {
        self.rootViewController = rootViewController
        self.dependencies = dependencies
    }
    
    public func start() {
        rootViewController.show(recentMessagesViewController, sender: rootViewController)
    }
    
    private func handleMoreContext(for viewController: UIViewController) {
        let contextMenuViewController = ContextMenuViewController()
        
        contextMenuViewController.addOption(ContextOption.reportOption({ _ in
            viewController.dismiss(animated: true) {
                viewController.showToast("The message has been reported!", severity: .success)
            }
        }))
        
        contextMenuViewController.modalPresentationStyle = .custom
        contextMenuViewController.modalPresentationCapturesStatusBarAppearance = true
        contextMenuViewController.transitioningDelegate = BottomSheetTransitioningDelegate.default
        
        viewController.present(contextMenuViewController, animated: true)
    }
}

// MARK: - MessagesViewController Delegate

extension RecentMessagesCoordinator: MessagesViewControllerDelegate {
    public func messagesViewController(_ messagesViewController: MessagesViewController, didSelect message: MessageViewModel, at indexPath: IndexPath) {
        let messageDetailViewController = MessageDetailViewController(viewModel: message)
        messageDetailViewController.delegate = self
        rootViewController.show(messageDetailViewController, sender: rootViewController)
    }
    
    public func messagesViewController(_ messagesViewController: MessagesViewController, moreContextFor message: MessageViewModel, at indexPath: IndexPath) {
        handleMoreContext(for: messagesViewController)
    }
    
}

// MARK: - MessageDetailViewController Delegate

extension RecentMessagesCoordinator: MessageDetailViewControllerDelegate {
    public func messageDetailViewController(_ messageDetailViewController: MessageDetailViewController, didUpdate message: MessageViewModel) {
        recentMessagesViewController.reloadSelectedIndexPath(with: message)
    }
    
    public func messageDetailViewController(_ messageDetailViewController: MessageDetailViewController, didDelete message: MessageViewModel) {
            recentMessagesViewController.deleteSelectedIndexPath(with: message)
        }
    
    public func messageDetailViewController(_ messageDetailViewController: MessageDetailViewController, moreContextFor message: MessageViewModel) {
        handleMoreContext(for: messageDetailViewController)
    }
    
}
