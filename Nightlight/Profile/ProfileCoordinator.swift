import UIKit

/// A coordinator for recent profile flow.
public class ProfileCoordinator: NSObject, TabBarCoordinator {
    public typealias Dependencies = KeychainManaging & StyleManaging
    public weak var parent: Coordinator?
    public var children = [Coordinator]()
    
    /// The required dependencies.
    private let dependencies: Dependencies

    /// The root view controller of the recent messages view controller.
    public let rootViewController: UINavigationController
    
    /// The current messages view controller index & message index path.
    private var currentInfo: (index: Int?, indexPath: IndexPath?)
    
    /// The active view controller handling appreciation events (eg. view or detail view).
    private weak var activeViewController: AppreciationEventHandling?
    
    /// An array of view controller for displaying messages.
    private lazy var messageViewControllers: [MessagesViewController] = {
        let messageDependencies = self.dependencies as! MessagesViewModel.Dependencies

        let viewModels = [
            MessagesViewModel(dependencies: messageDependencies, type: .received),
            MessagesViewModel(dependencies: messageDependencies, type: .sent),
            MessagesViewModel(dependencies: messageDependencies, type: .saved)
        ]
        
        let emptyViewDescriptions = [
            EmptyViewDescription.noReceivedMessages,
            EmptyViewDescription.noSentMessages,
            EmptyViewDescription.noSavedMessages
        ]
        
        return viewModels.enumerated().map { (i, viewModel) in
            let messagesViewController = MessagesViewController(viewModel: viewModel)
            messagesViewController.emptyViewDescription = emptyViewDescriptions[i]
            messagesViewController.delegate = self
            return messagesViewController
        }
    }()
    
    /// A view controller for displaying a profile.
    lazy var profileViewController: ProfileViewController = {
        let viewModel = ProfileViewModel(dependencies: dependencies as! ProfileViewModel.Dependencies)
        let viewController = ProfileViewController(viewModel: viewModel)
        
        viewController.tabBarItem = UITabBarItem(title: Strings.profile.profileTitle, image: UIImage.tab.profile, tag: 0)
        
        viewController.delegate = self
        viewController.messageViewControllers = messageViewControllers
        
        return viewController
    }()
    
    init(rootViewController: UINavigationController, dependencies: Dependencies) {
        self.dependencies = dependencies
        self.rootViewController = rootViewController
        
        super.init()
        
        rootViewController.delegate = self
    }
    
    public func start() {
        rootViewController.show(profileViewController, sender: rootViewController)
    }
    
    /**
     Handles extra context options for messages.
     
     - parameter message: the message that needs context handling.
     - parameter indexPath: the index path of the message that needs context handling.
     - parameter contextHandler: a view controller type object responsible for handling message context events.
     */
    private func handleMoreContext(for message: MessageViewModel, at indexPath: IndexPath, contextHandler: UIViewController & MessageContextHandling) {
        let contextMenuViewController = ContextMenuViewController()
        
        contextMenuViewController.addOption(ContextOption.reportOption({ _ in
            contextHandler.dismiss(animated: true) {
                contextHandler.didReportMessage(message: message, at: indexPath)
            }
        }))
        
        var username: String?
        
        if let accessToken = try? dependencies.keychainManager.string(for: KeychainKey.accessToken.rawValue),
            let jwt = try? JWTDecoder().decode(accessToken) {
            username = jwt["username"] as? String
        }
        
        if (username != nil || message.type == .received) && message.type != .saved {
            contextMenuViewController.addOption(ContextOption.deleteOption({ _ in
                contextMenuViewController.dismiss(animated: true) {
                    let alertController = UIAlertController(title: Strings.message.deleteMessage,
                                                            message: Strings.message.confirmDelete, preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: Strings.cancel, style: .cancel, handler: { _ in
                        alertController.dismiss(animated: true)
                    }))
                    
                    alertController.addAction(UIAlertAction(title: Strings.delete, style: .destructive, handler: { _ in
                        contextHandler.didDeleteMessage(message: message, at: indexPath)
                    }))
                    
                    contextHandler.present(alertController, animated: true)
                }
            }))
        }
        
        contextMenuViewController.modalPresentationStyle = .custom
        contextMenuViewController.modalPresentationCapturesStatusBarAppearance = true
        contextMenuViewController.transitioningDelegate = BottomSheetTransitioningDelegate.default
        
        contextHandler.present(contextMenuViewController, animated: true)
    }
    
    /**
     Handles the appreciation of a message.
     
     - parameter message: the message being appreciated.
     - parameter indexPath: the index path of the message being appreciated.
     */
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

extension ProfileCoordinator: MessagesViewControllerDelegate {
    public func messagesViewControllerAppreciation(_ messagesViewController: MessagesViewController, didComplete complete: Bool) {
        activeViewController = nil
        currentInfo = (nil, nil)
        rootViewController.dismiss(animated: true)
    }
    
    public func messagesViewController(_ messagesViewController: MessagesViewController, didAppreciate message: MessageViewModel, at indexPath: IndexPath) {

        handleAppreciation(for: message, at: indexPath)
        activeViewController = messagesViewController
        currentInfo = (messageViewControllers.firstIndex(of: messagesViewController), indexPath)
    }
    
    public func messagesViewController(_ messagesViewController: MessagesViewController, didSelect message: MessageViewModel, at indexPath: IndexPath) {
        
        let messageDetailViewController = MessageDetailViewController(viewModel: message)
        messageDetailViewController.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage.icon.back,
                                                                                       style: .plain,
                                                                                       target: self,
                                                                                       action: #selector(goBack))
        messageDetailViewController.delegate = self
        rootViewController.interactivePopGestureRecognizer?.delegate = self
        currentInfo = (messageViewControllers.firstIndex(of: messagesViewController), indexPath)
        
        rootViewController.pushViewController(messageDetailViewController, animated: true)
    }
    
    public func messagesViewController(_ messagesViewController: MessagesViewController, moreContextFor message: MessageViewModel, at indexPath: IndexPath) {
        handleMoreContext(for: message, at: indexPath, contextHandler: messagesViewController)
    }
    
    @objc private func goBack() {
        rootViewController.popViewController(animated: true)
    }
    
    public func childDidFinish(_ child: Coordinator) {
        removeChild(child)
        
        if child is SendAppreciationCoordinator {
            guard let indexPath = currentInfo.indexPath
                else { return }
            activeViewController?.didAppreciateMessage(at: indexPath)
        }
    }
}

// MARK: - MessageDetailViewController Delegate

extension ProfileCoordinator: MessageDetailViewControllerDelegate {
    public func messageDetailViewControllerAppreciation(_ messageDetailViewController: MessageDetailViewController, didComplete complete: Bool) {
        activeViewController = nil
        rootViewController.dismiss(animated: true)
    }
    
    public func messageDetailViewController(_ messageDetailViewController: MessageDetailViewController, didAppreciate message: MessageViewModel) {
        guard let indexPath = currentInfo.indexPath
            else { return }

        handleAppreciation(for: message, at: indexPath)
        activeViewController = messageDetailViewController
    }
    
    public func messageDetailViewController(_ messageDetailViewController: MessageDetailViewController, didUpdate message: MessageViewModel) {
        guard let (index, indexPath) = currentInfo as? (Int, IndexPath)
            else { return }
        
        messageViewControllers[index].didUpdateMessage(message, at: indexPath)
    }
    
    public func messageDetailViewController(_ messageDetailViewController: MessageDetailViewController, didDelete message: MessageViewModel) {
        guard let (index, indexPath) = currentInfo as? (Int, IndexPath)
            else { return }
        
            rootViewController.popViewController(animated: true)
            messageViewControllers[index].didDeleteMessage(message: message, at: indexPath)
            currentInfo = (nil, nil)
        }
    
    public func messageDetailViewController(_ messageDetailViewController: MessageDetailViewController, moreContextFor message: MessageViewModel) {
        guard let indexPath = currentInfo.indexPath
            else { return }

        handleMoreContext(for: message, at: indexPath, contextHandler: messageDetailViewController)
    }
}

// MARK: - ProfileViewController Delegate

extension ProfileCoordinator: ProfileViewControllerDelegate {
    public func profileViewControllerDidTapSettings(_ profileViewController: ProfileViewController) {
        let coordinator = SettingsCoordinator(rootViewController: rootViewController,
                                              dependencies: self.dependencies as! SettingsCoordinator.Dependencies)
        addChild(coordinator)
        
        coordinator.start()
    }
}

// MARK: - UINavigationController Delegate

extension ProfileCoordinator: UINavigationControllerDelegate {
    public func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        if navigationController.transitionCoordinator?.viewController(forKey: .to) is MessagesViewController {
            currentInfo = (nil, nil)
        }
    }
}

extension ProfileCoordinator: UIGestureRecognizerDelegate {}
