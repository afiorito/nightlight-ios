import UIKit

/// A coordinator for sending appreciation flow.
public class SendAppreciationCoordinator: Coordinator {
    public typealias Dependencies = NotificationObserving & KeychainManaging
    public weak var parent: Coordinator?
    public var children = [Coordinator]()
    
    /// The required depdendencies.
    private let dependencies: Dependencies
    
    /// The root view controller of the send appreciation view controller.
    private let rootViewController: UIViewController
    
    /// A view controller for sending appreciation.
    let sendAppreciationViewController: SendAppreciationViewController
    
    /// A view controller for buying tokens.
    private weak var buyTokensViewController: BuyTokensViewController?
    
    init(rootViewController: UIViewController, messageViewModel: MessageViewModel, dependencies: Dependencies) {
        self.rootViewController = rootViewController
        self.dependencies = dependencies
        
        let viewModel = SendAppreciationViewModel(dependencies: dependencies as! SendAppreciationViewModel.Dependencies,
                                                  message: messageViewModel.message)
        
        sendAppreciationViewController = SendAppreciationViewController(viewModel: viewModel)
        sendAppreciationViewController.delegate = self
        sendAppreciationViewController.modalPresentationStyle = .custom
        sendAppreciationViewController.modalPresentationCapturesStatusBarAppearance = true
        sendAppreciationViewController.transitioningDelegate = BottomSheetTransitioningDelegate.default
        
    }
    
    deinit {
        dependencies.notificationCenter.removeObserver(self,
                                                       name: Notification.Name(rawValue: NLNotification.didFinishTransaction.rawValue),
                                                       object: nil)
    }
    
    public func start() {
        NLNotification.didFinishTransaction.observe(target: self, selector: #selector(handleFinishedTransaction))
        
        rootViewController.present(sendAppreciationViewController, animated: true)
    }
    
    /**
     Handle the finished transaction notification.
     
     - parameter notification: an instance of a finish transaction notification.
     */
    @objc private func handleFinishedTransaction(_ notification: Notification) {
        guard buyTokensViewController != nil,
            let outcome = notification.userInfo?[NLNotification.didFinishTransaction.rawValue] as? IAPManager.TransactionOutcome
            else { return }
        
        switch outcome {
        case .success:
            buyTokensViewController = nil
            sendAppreciationViewController.dismiss(animated: true)
            sendAppreciationViewController.didCompletePurchase()
        case .cancelled:
            buyTokensViewController?.didCancelTransaction()
        case .failed:
            buyTokensViewController = nil
            sendAppreciationViewController.dismiss(animated: true)
            sendAppreciationViewController.didFailPurchase()
        }
    }
    
}

// MARK: - SendAppreciationViewController Delegate

extension SendAppreciationCoordinator: SendAppreciationViewControllerDelegate {
    public func sendAppreciationViewControllerDidTapActionButton(_ sendAppreciationViewController: SendAppreciationViewController) {
        
        let tokens = (try? dependencies.keychainManager.integer(forKey: KeychainKey.tokens.rawValue)) ?? 0
        
        // purchase more tokens
        if tokens <= 0 {
            let viewModel = BuyTokensViewModel(dependencies: dependencies as! BuyTokensViewModel.Dependencies)
            
            // need to fetch products before presenting so that collectionView has intrinsic size.
            viewModel.getProducts { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let products):
                    DispatchQueue.main.async {
                        let buyTokensViewController = BuyTokensViewController(viewModel: viewModel, products: products)
                        
                        buyTokensViewController.modalPresentationStyle = .custom
                        buyTokensViewController.modalPresentationCapturesStatusBarAppearance = true
                        buyTokensViewController.transitioningDelegate = ModalTransitioningDelegate.default
                        (buyTokensViewController.presentationController as? ModalPresentationController)?.presentationDelegate = self
                        
                        self.buyTokensViewController = buyTokensViewController
                        sendAppreciationViewController.present(buyTokensViewController, animated: true)
                    }
                case .failure:
                    DispatchQueue.main.async {
                        sendAppreciationViewController.didFailLoadingProducts()
                    }
                }
            }

        } else {
            // appreciate the message
            parent?.childDidFinish(self)
        }
    }
    
}

// MARK: - ModalPresentation Delegate

extension SendAppreciationCoordinator: ModalPresentationControllerDelegate {
    public func modalPresentationController(_ modalPresentationController: ModalPresentationController, didDismiss completed: Bool) {
        sendAppreciationViewController.didCancelPurchase()
    }
}
