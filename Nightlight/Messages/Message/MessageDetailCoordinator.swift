import UIKit

/// A coordinator for message detail flow.
public class MessageDetailCoordinator: NSObject, Coordinator {
    public typealias Dependencies = StyleManaging
    public weak var parent: Coordinator?
    public var children = [Coordinator]()

    /// The required dependencies.
    private let dependencies: Dependencies
    
    /// The type of message being shown.
    private let type: MessageType
    
    /// The message to show the detail for.
    private let message: Message
    
    /// The root view controller of for messages view controller.
    public let rootViewController: UINavigationController
    
    /// The delegate object that handles navigation events.
    public weak var navigationDelegate: MessageDetailCoordinatorNavigationDelegate?
    
    /// The view model for managing the state of the view.
    private lazy var viewModel: MessageViewModel = {
        MessageViewModel(message: message, type: .recent, dependencies: dependencies as! MessageViewModel.Dependencies)
    }()
    
    /// A view controller for showing a message.
    private lazy var messageDetailViewController: MessageDetailViewController = {
        let viewController = MessageDetailViewController(viewModel: viewModel)
        viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage.icon.back, style: .plain, target: rootViewController, action: #selector(rootViewController.popViewController))
        
        viewModel.uiDelegate = viewController
        viewModel.navigationDelegate = self
        
        return viewController
    }()
    
    public init(message: Message, type: MessageType, rootViewController: UINavigationController, dependencies: Dependencies) {
        self.message = message
        self.type = type
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
        
        contextMenuViewController.modalPresentationStyle = .custom
        contextMenuViewController.modalPresentationCapturesStatusBarAppearance = true
        contextMenuViewController.transitioningDelegate = BottomSheetTransitioningDelegate.default
        
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
