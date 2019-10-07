import UIKit

/// A coordinator for message detail flow.
public class MessageDetailCoordinator: NSObject, Coordinator {
    public typealias Dependencies = StyleManaging
    public weak var parent: Coordinator?
    public var children = [Coordinator]()

    /// The required dependencies.
    private let dependencies: Dependencies
    
    /// The root view controller of for messages view controller.
    public let rootViewController: UINavigationController
    
    /// The delegate object that handles navigation events.
    public weak var navigationDelegate: MessageDetailCoordinatorNavigationDelegate?
    
    /// The view model for managing the state of the view.
    private let viewModel: MessageViewModel
    
    // A transition for presenting view controllers from below.
    private let bottomTransition = BottomTransition()
    
    /// A view controller for showing a message.
    private lazy var messageDetailViewController: MessageDetailViewController = {
        let viewController = MessageDetailViewController(viewModel: viewModel)
        viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage.icon.back, style: .plain, target: rootViewController, action: #selector(rootViewController.popViewController))
        
        viewModel.uiDelegate = viewController
        viewModel.navigationDelegate = self
        
        return viewController
    }()
    
    public init(message: Message, type: MessageType, rootViewController: UINavigationController, dependencies: Dependencies) {
        self.viewModel = MessageViewModel(message: message, type: type, dependencies: dependencies as! MessageViewModel.Dependencies)
        self.rootViewController = rootViewController
        self.dependencies = dependencies
    }
    
    public init(messageId: Int, rootViewController: UINavigationController, dependencies: Dependencies) {
        self.viewModel = MessageViewModel(messageId: messageId, dependencies: dependencies as! MessageViewModel.Dependencies)
        self.rootViewController = rootViewController
        self.dependencies = dependencies
    }
    
    public func start() {
        rootViewController.interactivePopGestureRecognizer?.delegate = self
        rootViewController.pushViewController(messageDetailViewController, animated: true)
    }
}

// MARK: - Message Navigation Delegate

extension MessageDetailCoordinator: MessageNavigationDelegate {
    public func didDelete(message: Message) {
        rootViewController.popViewController(animated: true)
        navigationDelegate?.messageDetailCoordinatorDidDelete(message: message)
    }
    
    public func didUpdate(message: Message) {
        navigationDelegate?.messageDetailCoordinatorDidUpdate(message: message)
    }
    
    public func showAppreciationSheet(for message: Message) {
        let dependencies = self.dependencies as! SendAppreciationCoordinator.Dependencies
        let coordinator = SendAppreciationCoordinator(rootViewController: rootViewController, message: message, dependencies: dependencies)
        coordinator.navigationDelegate = self
        addChild(coordinator)
        coordinator.start()
    }
    
    public func showContextMenu(for message: Message, with actions: [MessageContextAction]) {
        let contextMenuViewController = ContextMenuViewController()
        
        for action in actions {
            let completion = { [weak self, weak contextMenuViewController] in
                contextMenuViewController?.dismiss(animated: true)
                self?.viewModel.didFinishPresentingContextMenu(with: action)
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
            
            let sourceView = messageDetailViewController.messageContentView.contextButton
            
            contextMenuViewController.view.layoutIfNeeded()
            let size = contextMenuViewController.view.systemLayoutSizeFitting(CGSize(width: 320, height: UIView.layoutFittingCompressedSize.height), withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
            
            contextMenuViewController.preferredContentSize = size
            contextMenuViewController.popoverPresentationController?.sourceView = sourceView
            contextMenuViewController.popoverPresentationController?.permittedArrowDirections = [.right]
        }
        
        messageDetailViewController.present(contextMenuViewController, animated: true)
    }
    
}

// MARK: - SendAppreciationCoordinator Navigation Delegate

extension MessageDetailCoordinator: SendAppreciationCoordinatorNavigationDelegate {
    public func sendAppreciationCoordinatorDidAppreciate(message: Message) {
        viewModel.didUpdate(message: message)
        navigationDelegate?.messageDetailCoordinatorDidUpdate(message: message)
    }
    
    public func sendAppreciationCoordinatorDidFailToAppreciate(message: Message, with error: MessageError) {
        viewModel.didFailToAppreciate(with: error)
    }
    
}

extension MessageDetailCoordinator: UIGestureRecognizerDelegate {}
