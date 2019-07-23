import UIKit

public class ProfileCoordinator: TabBarCoordinator {
    public typealias Dependencies = KeychainManaging & StyleManaging

    public weak var parent: Coordinator?
    public var children = [Coordinator]()
    
    private let dependencies: Dependencies

    public let rootViewController: UIViewController
    
    private var previousMessagesViewControllerIndex: Int?
    
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
    
    lazy var profileViewController: ProfileViewController = {
        let viewModel = ProfileViewModel(dependencies: dependencies as! ProfileViewModel.Dependencies)
        let viewController = ProfileViewController(viewModel: viewModel)
        
        viewController.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(named: "tb_profile"), tag: 0)
        
        viewController.messageViewControllers = messageViewControllers
        
        return viewController
    }()
    
    init(rootViewController: UIViewController, dependencies: Dependencies) {
        self.dependencies = dependencies
        self.rootViewController = rootViewController
    }
    
    public func start() {
        rootViewController.show(profileViewController, sender: rootViewController)
    }
    
    private func handleMoreContext(for message: MessageViewModel, at indexPath: IndexPath?, contextHandler: UIViewController & MessageContextHandling) {
        let contextMenuViewController = ContextMenuViewController()
        
        contextMenuViewController.addOption(ContextOption.reportOption({ _ in
            contextHandler.dismiss(animated: true) {
                contextHandler.didReportMessage(message: message, at: indexPath)
            }
        }))
        
        var username: String?
        
        if let accessToken = try? dependencies.keychainManager.string(forKey: KeychainKey.accessToken.rawValue),
            let jwt = try? JWTDecoder().decode(accessToken) {
            username = jwt["username"] as? String
        }
        
        if (username != nil || message.type == .received) && message.type != .saved {
            contextMenuViewController.addOption(ContextOption.deleteOption({ _ in
                contextMenuViewController.dismiss(animated: true) {
                    let alertController = UIAlertController(title: "Delete Message", message: "Are you sure you want to delete this message? This action is irreversible.", preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
                        alertController.dismiss(animated: true)
                    }))
                    
                    alertController.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
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

}

// MARK: - MessagesViewController Delegate

extension ProfileCoordinator: MessagesViewControllerDelegate {
    public func messagesViewController(_ messagesViewController: MessagesViewController, didSelect message: MessageViewModel, at indexPath: IndexPath) {
        let messageDetailViewController = MessageDetailViewController(viewModel: message)
        messageDetailViewController.delegate = self
        previousMessagesViewControllerIndex = messageViewControllers.firstIndex(of: messagesViewController)
        rootViewController.show(messageDetailViewController, sender: rootViewController)
    }
    
    public func messagesViewController(_ messagesViewController: MessagesViewController, moreContextFor message: MessageViewModel, at indexPath: IndexPath) {
        handleMoreContext(for: message, at: indexPath, contextHandler: messagesViewController)
    }
    
}

// MARK: - MessageDetailViewController Delegate

extension ProfileCoordinator: MessageDetailViewControllerDelegate {
    public func messageDetailViewController(_ messageDetailViewController: MessageDetailViewController, didUpdate message: MessageViewModel) {
        
        if let index = previousMessagesViewControllerIndex {
            messageViewControllers[index].reloadSelectedIndexPath(with: message)
            previousMessagesViewControllerIndex = nil
        }
    }
    
    public func messageDetailViewController(_ messageDetailViewController: MessageDetailViewController, didDelete message: MessageViewModel) {
            if let index = previousMessagesViewControllerIndex {
                (rootViewController as? UINavigationController)?.popViewController(animated: true)
                messageViewControllers[index].deleteSelectedIndexPath(with: message)
                previousMessagesViewControllerIndex = nil
            }
        }
    
    public func messageDetailViewController(_ messageDetailViewController: MessageDetailViewController, moreContextFor message: MessageViewModel) {
        handleMoreContext(for: message, at: nil, contextHandler: messageDetailViewController)
    }
    
}
