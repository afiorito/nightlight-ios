import UIKit

/// A coordinator for purchasing tokens flow.
public class BuyTokensCoordinator: Coordinator {
    public typealias Dependencies = StyleManaging & NotificationObserving
    public weak var parent: Coordinator?
    public var children = [Coordinator]()
    
    /// The required depdendencies.
    private let dependencies: Dependencies
    
    /// The root view controller of the send appreciation view controller.
    private let rootViewController: UIViewController
    
    /// The delegate object that handles navigation events.
    public weak var navigationDelegate: BuyTokensCoordinatorNavigationDelegate?
    
    /// The view model for managing the state of the view.
    private lazy var viewModel: BuyTokensViewModel = {
        BuyTokensViewModel(dependencies: dependencies as! BuyTokensViewModel.Dependencies)
    }()
    
    /// A view controller for sending appreciation.
    private lazy var buyTokensViewController: BuyTokensViewController = {
        let buyTokensViewController = BuyTokensViewController(viewModel: viewModel)
        viewModel.uiDelegate = buyTokensViewController
        
        return buyTokensViewController
    }()
    
    public init(rootViewController: UIViewController, dependencies: Dependencies) {
        self.rootViewController = rootViewController
        self.dependencies = dependencies
    }
    
    public func start() {
        NLNotification.didFinishTransaction.observe(target: self, selector: #selector(handleFinishedTransaction))

        buyTokensViewController.modalPresentationStyle = .custom
        buyTokensViewController.modalPresentationCapturesStatusBarAppearance = true
        buyTokensViewController.transitioningDelegate = ModalTransitioningDelegate.default
        (buyTokensViewController.presentationController as? ModalPresentationController)?.presentationDelegate = self
        
        viewModel.fetchProducts { [weak self] in
            guard let self = self else { return }
            self.rootViewController.present(self.buyTokensViewController, animated: true)
        }
    }
    
    /**
     Handle the finished transaction notification.
     
     - parameter notification: an instance of a finish transaction notification.
     */
    @objc private func handleFinishedTransaction(_ notification: Notification) {
        guard let outcome = notification.userInfo?[NLNotification.didFinishTransaction.rawValue] as? IAPManager.TransactionOutcome
            else { return }
        
        switch outcome {
        case .success:
            buyTokensViewController.dismiss(animated: true)
            navigationDelegate?.buyTokensCoordinatorDismiss(with: outcome)
        case .cancelled:
            viewModel.didCancelTransaction()
        case .failed:
            buyTokensViewController.dismiss(animated: true)
            navigationDelegate?.buyTokensCoordinatorDismiss(with: outcome)
        }
    }
    
    deinit {
        dependencies.notificationCenter.removeObserver(self, name: Notification.Name(rawValue: NLNotification.didFinishTransaction.rawValue), object: nil)
    }
}

// MARK: - ModalPresentationController Delegate

extension BuyTokensCoordinator: ModalPresentationControllerDelegate {
    public func modalPresentationController(_ modalPresentationController: ModalPresentationController, didDismiss completed: Bool) {
        navigationDelegate?.buyTokensCoordinatorDismiss(with: .cancelled)
        parent?.childDidFinish(self)
    }
}
