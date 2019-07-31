import UIKit

public protocol SendAppreciationCoordinatorDelegate: class {
    func sendAppreciationCoordinatorDidAppreciate(_ sendAppreciationCoordinator: SendAppreciationCoordinator)
    func sendAppreciationCoordinatorDidFailAppreciate(_ sendAppreciationCoordinator: SendAppreciationCoordinator)
}

public class SendAppreciationCoordinator: Coordinator {
    public typealias Dependencies = KeychainManaging

    public weak var parent: Coordinator?
    
    public var children = [Coordinator]()
    
    private let dependencies: Dependencies
    
    private let rootViewController: UIViewController
    
    public weak var delegate: SendAppreciationCoordinatorDelegate?
    
    let sendAppreciationViewController: SendAppreciationViewController
    
    init(rootViewController: UIViewController, messageViewModel: MessageViewModel, dependencies: Dependencies) {
        self.rootViewController = rootViewController
        self.dependencies = dependencies
        
        let viewModel = SendAppreciationViewModel(dependencies: dependencies as! SendAppreciationViewModel.Dependencies, message: messageViewModel.message)
        
        sendAppreciationViewController = SendAppreciationViewController(viewModel: viewModel)
        sendAppreciationViewController.modalPresentationStyle = .custom
        sendAppreciationViewController.modalPresentationCapturesStatusBarAppearance = true
        sendAppreciationViewController.transitioningDelegate = BottomSheetTransitioningDelegate.default
        
    }
    
    public func start() {
        rootViewController.present(sendAppreciationViewController, animated: true)
    }
    
    
}

extension SendAppreciationCoordinator: SendAppreciationViewControllerDelegate {
    public func sendAppreciationViewControllerDidAppreciate(_ buyAppreciationViewController: SendAppreciationViewController) {
        delegate?.sendAppreciationCoordinatorDidAppreciate(self)
        parent?.childDidFinish(self)
    }
    
    public func sendAppreciationViewControllerDidFailAppreciate(_ buyAppreciationViewController: SendAppreciationViewController) {
        delegate?.sendAppreciationCoordinatorDidFailAppreciate(self)
        parent?.childDidFinish(self)
    }
    
    public func sendAppreciationViewControllerDidTapActionButton(_ sendAppreciationViewController: SendAppreciationViewController) {
        let numTokens = (try? dependencies.keychainManager.integer(forKey: KeychainKey.numTokens.rawValue)) ?? 0
        
        if numTokens > 0 {
            sendAppreciationViewController.appreciateMessage()
        } else {
            // present buy tokens
        }
    }
    
    
}
