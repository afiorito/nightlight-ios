import UIKit

public class SendMessageCoordinator: TabBarCoordinator {
    public typealias Dependencies = StyleManaging
    public weak var parent: Coordinator?
    public var children = [Coordinator]()
    
    public var rootViewController: UINavigationController
    
    public lazy var sendMessageViewController: SendMessageViewController = {
        let viewModel = SendMessageViewModel(dependencies: dependencies as! SendMessageViewModel.Dependencies)
        
        let viewController = SendMessageViewController(viewModel: viewModel)
        viewController.delegate = self
        viewController.title = "New Message"
        
        return viewController
    }()
    
    private let dependencies: Dependencies
    
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
