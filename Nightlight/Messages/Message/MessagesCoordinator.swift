import UIKit

/// A coordinator for messages flow.
public class MessagesCoordinator: NSObject, TabBarCoordinator {
    public typealias Dependencies = StyleManaging
    public weak var parent: Coordinator?
    public var children = [Coordinator]()

    /// The required dependencies.
    private let dependencies: Dependencies
    
    /// The type of messages being shown.
    private let type: MessageType
    
    /// The root view controller of for messages view controller.
    public let rootViewController: UINavigationController
    
    /// An index path for denoting the current message being interacted with.
    private var activeIndexPath: IndexPath?
    
    /// A boolean that determines if the view controller is presented in the root view controller.
    public var presentsInRootViewController = true
    
    /// The view model for managing the state of the view.
    private lazy var viewModel: MessagesViewModel = {
        MessagesViewModel(dependencies: dependencies as! MessagesViewModel.Dependencies, type: type)
    }()
    
    // A transition for presenting view controllers from below.
    private let bottomTransition = BottomTransition()
    
    /// A view controller for displaying a list of messages.
    public lazy var messagesViewController: MessagesViewController = {
        let viewController = MessagesViewController(viewModel: viewModel)

        viewModel.uiDelegate = viewController
        viewModel.navigationDelegate = self
        
        switch type {
        case .recent:
            // recent messages view controller is presented in a navigation controller.
            viewController.title = Strings.message.recentMessagesNavTitle
            viewController.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
            viewController.tabBarItem = UITabBarItem(title: Strings.message.recentMessagesTabTitle, image: UIImage.tab.recent, tag: 0)
            viewController.emptyViewDescription = EmptyViewDescription.noRecentMessages
        case .received:
            viewController.emptyViewDescription = EmptyViewDescription.noReceivedMessages
        case .sent:
            viewController.emptyViewDescription = EmptyViewDescription.noSentMessages
        case .saved:
            viewController.emptyViewDescription = EmptyViewDescription.noSavedMessages
        }
        
        return viewController
    }()
    
    public init(type: MessageType, rootViewController: UINavigationController, dependencies: Dependencies) {
        self.type = type
        self.rootViewController = rootViewController
        self.dependencies = dependencies
    }
    
    public func start() {
        rootViewController.delegate = self
        rootViewController.pushViewController(messagesViewController, animated: true)
    }
    
    public func childDidFinish(_ child: Coordinator) {
        removeChild(child)
        activeIndexPath = nil
        rootViewController.delegate = self
    }
}

// MARK: - SendAppreciationCoordinatorNavigation Delegate

extension MessagesCoordinator: SendAppreciationCoordinatorNavigationDelegate {
    public func sendAppreciationCoordinatorDidAppreciate(message: Message) {
        if let indexPath = activeIndexPath {
            viewModel.didUpdate(message: message, at: indexPath)
            activeIndexPath = nil
        }
    }
    
    public func sendAppreciationCoordinatorDidFailToAppreciate(message: Message, with error: MessageError) {
        if let indexPath = activeIndexPath {
            viewModel.didFailToAppreciateMessage(with: error, at: indexPath)
            activeIndexPath = nil
        }
    }
}

// MARK: - MessagesNavigation Delegate

extension MessagesCoordinator: MessagesNavigationDelegate {
    public func showAppreciationSheet(for message: Message, at indexPath: IndexPath) {
        activeIndexPath = indexPath

        let dependencies = self.dependencies as! SendAppreciationCoordinator.Dependencies
        let coordinator = SendAppreciationCoordinator(rootViewController: rootViewController, message: message, dependencies: dependencies)
        coordinator.navigationDelegate = self
        addChild(coordinator)
        coordinator.start()
    }
    
    public func showContextMenu(for message: Message, with actions: [MessageContextAction], at indexPath: IndexPath) {
        activeIndexPath = indexPath
        
        let contextMenuViewController = ContextMenuViewController()
        
        for action in actions {
            let completion = { [weak self, weak contextMenuViewController] in
                contextMenuViewController?.dismiss(animated: true)
                self?.viewModel.didFinishPresentingContextMenu(with: action, at: indexPath)
            }
            
            switch action {
            case .report:
                contextMenuViewController.addOption(ContextOption.reportOption({ _ in completion() }))
            case .delete:
                contextMenuViewController.addOption(ContextOption.deleteOption({ [weak contextMenuViewController] _ in
                    let alertController = UIAlertController(title: Strings.message.deleteMessage,
                                                            message: Strings.message.confirmDelete, preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: Strings.cancel, style: .cancel, handler: { _ in
                        alertController.dismiss(animated: true)
                    }))
                    
                    alertController.addAction(UIAlertAction(title: Strings.delete, style: .destructive, handler: { _ in
                        completion()
                    }))
                    
                    contextMenuViewController?.present(alertController, animated: true)
                }))
            }
        }
        
        if UIDevice.current.userInterfaceIdiom != .pad {
            contextMenuViewController.modalPresentationStyle = .custom
            contextMenuViewController.transitioningDelegate = bottomTransition
        } else {
            contextMenuViewController.modalPresentationStyle = .popover
            
            var sourceView = messagesViewController.view
            
            if let messagesView = messagesViewController.view as? MessagesView, let messageCell = messagesView.tableView.cellForRow(at: indexPath) as? MessageTableViewCell {
                sourceView = messageCell.messageContentView.contextButton
            }
            
            contextMenuViewController.view.layoutIfNeeded()
            let size = contextMenuViewController.view.systemLayoutSizeFitting(CGSize(width: 320, height: UIView.layoutFittingCompressedSize.height), withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)

            contextMenuViewController.preferredContentSize = size
            contextMenuViewController.popoverPresentationController?.sourceView = sourceView
            contextMenuViewController.popoverPresentationController?.permittedArrowDirections = [.right]
        }

        messagesViewController.present(contextMenuViewController, animated: true)
    }
    
    public func showDetail(message: Message, at indexPath: IndexPath) {
        activeIndexPath = indexPath
        let coordinator = MessageDetailCoordinator(message: message, type: type, rootViewController: rootViewController, dependencies: dependencies)
        coordinator.navigationDelegate = self
        addChild(coordinator)
        coordinator.start()
    }

}

// MARK: - MessageDetailCoordinator Navigation Delegate

extension MessagesCoordinator: MessageDetailCoordinatorNavigationDelegate {
    public func messageDetailCoordinatorDidDelete(message: Message) {
        if let indexPath = activeIndexPath {
            viewModel.didDeleteMessage(at: indexPath)
        }
    }
    
    public func messageDetailCoordinatorDidUpdate(message: Message) {
        if let indexPath = activeIndexPath {
            viewModel.didUpdate(message: message, at: indexPath)
        }
    }

}

// MARK: - UINavigationController Delegate

extension MessagesCoordinator: UINavigationControllerDelegate {
    public func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        
        // reset coordinator state when navigating back to previous view controller.
        if navigationController.transitionCoordinator?.viewController(forKey: .to) is MessagesViewController {
            removeChild(with: MessageDetailCoordinator.self)
            activeIndexPath = nil
        }
    }
}
