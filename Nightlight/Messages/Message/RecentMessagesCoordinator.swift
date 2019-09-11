import UIKit

protocol AppreciationEventHandling: class {
    func didAppreciateMessage(at indexPath: IndexPath)
}

/// A coordinator for recent messages flow.
public class RecentMessagesCoordinator: NSObject, TabBarCoordinator {
    public typealias Dependencies = StyleManaging
    public weak var parent: Coordinator?
    public var children = [Coordinator]()
    
    /// The required dependencies.
    private let dependencies: Dependencies
    
    /// The root view controller of the recent messages view controller.
    public let rootViewController: UINavigationController
    
    /// The current index path for a message.
    private var currentIndexPath: IndexPath?
    
    /// The active view controller handling appreciation events (eg. view or detail view).
    private weak var activeViewController: AppreciationEventHandling?
    
    /// A view controller for displaying recent messages.
    lazy var recentMessagesViewController: MessagesViewController = {
        let viewModel = MessagesViewModel(dependencies: dependencies as! MessagesViewModel.Dependencies, type: .recent)
        let viewController = MessagesViewController(viewModel: viewModel)
        
        viewController.delegate = self
        viewController.title = Strings.message.recentMessagesNavTitle
        
        viewController.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        viewController.tabBarItem = UITabBarItem(title: Strings.message.recentMessagesTabTitle, image: UIImage.tab.recent, tag: 0)
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
    
    /**
     Handles extra context options for messages.
     
     - parameter message: the message that needs context handling.
     - parameter indexPath: the index path of the message that needs context handling.
     - parameter handler: a view controller type object responsible for handling message context events.
     */
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
    
    /**
     Handles the appreciation of a message.
     
     - parameter message: the message being appreciated.
     - parameter indexPath: the index path of the message being appreciated.
     */
    private func handleAppreciation(for message: MessageViewModel, at indexPath: IndexPath) {
        guard !message.isAppreciated
            else { return }
        
        let coordinator = SendAppreciationCoordinator(rootViewController: rootViewController, messageViewModel: message,
                                                      dependencies: dependencies as! SendAppreciationCoordinator.Dependencies)
        addChild(coordinator)
        coordinator.start()
    }
    
    public func childDidFinish(_ child: Coordinator) {
        removeChild(child)
        
        if child is SendAppreciationCoordinator {
            guard let indexPath = currentIndexPath
                else { return }
            activeViewController?.didAppreciateMessage(at: indexPath)
        }
    }
}

// MARK: - MessagesViewController Delegate

extension RecentMessagesCoordinator: MessagesViewControllerDelegate {
    public func messagesViewControllerAppreciation(_ messagesViewController: MessagesViewController, didComplete completed: Bool) {
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
        // reset coordinator state when navigating back to previous view controller.
        if navigationController.transitionCoordinator?.viewController(forKey: .to) is MessagesViewController {
            currentIndexPath = nil
        }
    }
}
