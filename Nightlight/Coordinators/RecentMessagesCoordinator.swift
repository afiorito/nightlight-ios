import UIKit

protocol AppreciationEventHandling: class {
    func didAppreciateMessage(at indexPath: IndexPath)
}

public class RecentMessagesCoordinator: NSObject, TabBarCoordinator {
    public typealias Dependencies = StyleManaging

    public weak var parent: Coordinator?
    public var children = [Coordinator]()
    
    private let dependencies: Dependencies
    
    public let rootViewController: UINavigationController
    private var currentIndexPath: IndexPath?
    
    private weak var activeViewController: AppreciationEventHandling?
    
    lazy var recentMessagesViewController: MessagesViewController = {
        let viewModel = MessagesViewModel(dependencies: dependencies as! MessagesViewModel.Dependencies, type: .recent)
        let viewController = MessagesViewController(viewModel: viewModel)
        
        viewController.delegate = self
        viewController.navigationItem.titleView = {
            let navFrame = rootViewController.navigationBar.frame
            let titleView = LabelTitleView(frame: CGRect(x: 15, y: 0,
                                                         width: rootViewController.view.frame.width - 30,
                                                         height: navFrame.height))
            titleView.title = "Recent Messages"
            return titleView
        }()
        
        viewController.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        viewController.tabBarItem = UITabBarItem(title: "Recent", image: UIImage(named: "tb_recent"), tag: 0)
        viewController.emptyViewDescription = EmptyViewDescription.noRecentMessages
        
        return viewController
    }()
    
    init(rootViewController: UINavigationController, dependencies: Dependencies) {
        self.rootViewController = rootViewController
        self.dependencies = dependencies
        
        super.init()
        
        self.rootViewController.delegate = self
    }
    
    public func start() {
        rootViewController.show(recentMessagesViewController, sender: rootViewController)
    }
    
    private func handleMoreContext(for message: MessageViewModel, at indexPath: IndexPath, handler: UIViewController & MessageContextHandling) {
        let contextMenuViewController = ContextMenuViewController()
        
        contextMenuViewController.addOption(ContextOption.reportOption({ _ in
            handler.dismiss(animated: true) {
                handler.didReportMessage(message: message, at: indexPath)
            }
        }))
        
        contextMenuViewController.modalPresentationStyle = .custom
        contextMenuViewController.modalPresentationCapturesStatusBarAppearance = true
        contextMenuViewController.transitioningDelegate = BottomSheetTransitioningDelegate.default
        
        handler.present(contextMenuViewController, animated: true)
    }
    
    public func childDidFinish(_ child: Coordinator) {
        removeChild(child)
        
        if child is SendAppreciationCoordinator {
            guard let indexPath = currentIndexPath
                else { return }
            activeViewController?.didAppreciateMessage(at: indexPath)
        }
    }
    
    private func handleAppreciation(for message: MessageViewModel, at indexPath: IndexPath) {
        guard !message.isAppreciated
            else { return }
        
        let childCoordinator = SendAppreciationCoordinator(rootViewController: rootViewController,
                                                           messageViewModel: message,
                                                           dependencies: dependencies as! SendAppreciationCoordinator.Dependencies)
        addChild(childCoordinator)
        
        childCoordinator.start()
    }
}

// MARK: - MessagesViewController Delegate

extension RecentMessagesCoordinator: MessagesViewControllerDelegate {
    public func messagesViewControllerAppreciation(_ messagesViewController: MessagesViewController, didComplete complete: Bool) {
        activeViewController = nil
        currentIndexPath = nil
        rootViewController.dismiss(animated: true)
    }
    
    public func messagesViewController(_ messagesViewController: MessagesViewController, didAppreciate message: MessageViewModel, at indexPath: IndexPath) {
        
        handleAppreciation(for: message, at: indexPath)
        
        activeViewController = messagesViewController
        currentIndexPath = indexPath
    }
    
    public func messagesViewController(_ messagesViewController: MessagesViewController, didSelect message: MessageViewModel, at indexPath: IndexPath) {
        
        currentIndexPath = indexPath
        
        let messageDetailViewController = MessageDetailViewController(viewModel: message)
        messageDetailViewController.delegate = self
        rootViewController.pushViewController(messageDetailViewController, animated: true)
    }
    
    public func messagesViewController(_ messagesViewController: MessagesViewController, moreContextFor message: MessageViewModel, at indexPath: IndexPath) {
        handleMoreContext(for: message, at: indexPath, handler: messagesViewController)
    }
    
}

// MARK: - MessageDetailViewController Delegate

extension RecentMessagesCoordinator: MessageDetailViewControllerDelegate {
    public func messageDetailViewControllerAppreciation(_ messageDetailViewController: MessageDetailViewController, didComplete complete: Bool) {
        activeViewController = nil
        rootViewController.dismiss(animated: true)
    }
    
    public func messageDetailViewController(_ messageDetailViewController: MessageDetailViewController, didAppreciate message: MessageViewModel) {
        guard let indexPath = currentIndexPath else { return }
        
        handleAppreciation(for: message, at: indexPath)
        activeViewController = messageDetailViewController
    }
    
    public func messageDetailViewController(_ messageDetailViewController: MessageDetailViewController, didUpdate message: MessageViewModel) {
        guard let indexPath = currentIndexPath else { return }

        recentMessagesViewController.didUpdateMessage(message, at: indexPath)
    }
    
    public func messageDetailViewController(_ messageDetailViewController: MessageDetailViewController, didDelete message: MessageViewModel) {
        // can't delete messages from the recent messages view controller.
    }
    
    public func messageDetailViewController(_ messageDetailViewController: MessageDetailViewController, moreContextFor message: MessageViewModel) {
        guard let indexPath = currentIndexPath
            else { return }

        handleMoreContext(for: message, at: indexPath, handler: messageDetailViewController)
    }
    
}

// MARK: - UINavigationController Delegate

extension RecentMessagesCoordinator: UINavigationControllerDelegate {
    public func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        if navigationController.transitionCoordinator?.viewController(forKey: .to) is MessagesViewController {
            currentIndexPath = nil
        }
    }
}
