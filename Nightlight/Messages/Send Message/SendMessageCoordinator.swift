import UIKit

/// A coordinator for sending messages flow.
public class SendMessageCoordinator: TabBarCoordinator {
    public typealias Dependencies = StyleManaging
    public weak var parent: Coordinator?
    public var children = [Coordinator]()
    
    /// The required depdendencies.
    private let dependencies: Dependencies
    
    /// The root view controller of the sent message view controller.
    public var rootViewController: UINavigationController
    
    /// a view controller for sending a message.
    public lazy var sendMessageViewController: SendMessageViewController = {
        let viewModel = SendMessageViewModel(dependencies: dependencies as! SendMessageViewModel.Dependencies)
        
        let viewController = SendMessageViewController(viewModel: viewModel)
        viewController.delegate = self
        viewController.title = Strings.message.sendMessageTitle
        
        return viewController
    }()
    
    init(rootViewController: UINavigationController, dependencies: Dependencies) {
        self.dependencies = dependencies
        self.rootViewController = rootViewController
    }
    
    public func start() {
        rootViewController.show(sendMessageViewController, sender: rootViewController)
    }    
}

// MARK: - SendMessageViewController Delegate

extension SendMessageCoordinator: SendMessageViewControllerDelegate {
    public func sendMessageViewController(_ sendMessageViewController: SendMessageViewController, didSend message: MessageViewModel) {
        sendMessageViewController.dismiss(animated: true)
    }
    
    public func sendMessageViewControllerDidCancel(_ sendMessageViewController: SendMessageViewController) {
        sendMessageViewController.dismiss(animated: true)
    }
    
}
