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
    
    /// The view model for managing the state of the view.
    private lazy var viewModel: SendMessageViewModel = {
        SendMessageViewModel(dependencies: dependencies as! SendMessageViewModel.Dependencies)
    }()
    
    /// A view controller for sending a message.
    public lazy var sendMessageViewController: SendMessageViewController = {
        let viewController = SendMessageViewController(viewModel: viewModel)
        viewController.title = Strings.message.sendMessageTitle
        
        viewModel.uiDelegate = viewController
        viewModel.navigationDelegate = self
        
        return viewController
    }()
    
    public init(rootViewController: UINavigationController, dependencies: Dependencies) {
        self.dependencies = dependencies
        self.rootViewController = rootViewController
    }
    
    public func start() {
        if UIDevice.current.userInterfaceIdiom == .pad {
            rootViewController.modalPresentationStyle = .formSheet
        }
        
        rootViewController.pushViewController(sendMessageViewController, animated: true)
    }
}

// MARK: - SendMessage Navigation Delegate

extension SendMessageCoordinator: SendMessageNavigationDelegate {
    public func didSend(message: Message) {
        sendMessageViewController.dismiss(animated: true)
        parent?.childDidFinish(self)
    }
    
    public func didFinishSendingMessage() {
        sendMessageViewController.dismiss(animated: true)
        parent?.childDidFinish(self)
    }
    
}
