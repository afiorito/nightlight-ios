import UIKit

/// A coordinator for sending appreciation flow.
public class SendAppreciationCoordinator: Coordinator {
    public typealias Dependencies = StyleManaging & NotificationObserving & KeychainManaging
    public weak var parent: Coordinator?
    public var children = [Coordinator]()
    
    /// The required depdendencies.
    private let dependencies: Dependencies
    
    /// The delegate object that handles navigation events.
    public weak var navigationDelegate: SendAppreciationCoordinatorNavigationDelegate?
    
    /// The root view controller of the send appreciation view controller.
    private let rootViewController: UIViewController
    
    /// A view controller for sending appreciation.
    private let sendAppreciationViewController: SendAppreciationViewController
    
    /// The view model for managing the state of the view.
    private let viewModel: SendAppreciationViewModel
    
    /// A view controller for buying tokens.
    private weak var buyTokensViewController: BuyTokensViewController?
    
    public init(rootViewController: UIViewController, message: Message, dependencies: Dependencies) {
        self.rootViewController = rootViewController
        self.dependencies = dependencies

        viewModel = SendAppreciationViewModel(dependencies: dependencies as! SendAppreciationViewModel.Dependencies, message: message)
        
        sendAppreciationViewController = SendAppreciationViewController(viewModel: viewModel)
        
        viewModel.navigationDelegate = self
        viewModel.uiDelegate = sendAppreciationViewController
    }
    
    public func start() {
        if UIDevice.current.userInterfaceIdiom != .pad {
            sendAppreciationViewController.modalPresentationStyle = .custom
            sendAppreciationViewController.modalPresentationCapturesStatusBarAppearance = true
            sendAppreciationViewController.transitioningDelegate = BottomSheetTransitioningDelegate.default
        } else {
            let targetSize = CGSize(width: 500, height: UIView.layoutFittingCompressedSize.height)
            
            let intrinsicSize = sendAppreciationViewController
                                    .view.systemLayoutSizeFitting(targetSize,
                                                                  withHorizontalFittingPriority: .required,
                                                                  verticalFittingPriority: .fittingSizeLevel)
            sendAppreciationViewController.preferredContentSize = intrinsicSize
            sendAppreciationViewController.modalPresentationStyle = .formSheet
        }

        rootViewController.present(sendAppreciationViewController, animated: true)
    }
    
}

// MARK: - SendAppreciationCoordinator Delegate

extension SendAppreciationCoordinator: SendAppreciationNavigationDelegate {
    public func didAppreciate(message: Message) {
        navigationDelegate?.sendAppreciationCoordinatorDidAppreciate(message: message)
        sendAppreciationViewController.dismiss(animated: true)
        parent?.childDidFinish(self)
    }
    
    public func didFailToAppreciate(message: Message, with error: MessageError) {
        navigationDelegate?.sendAppreciationCoordinatorDidFailToAppreciate(message: message, with: error)
        sendAppreciationViewController.dismiss(animated: true)
        parent?.childDidFinish(self)
    }
    
    public func showBuyTokensModal() {
        let coordinator = BuyTokensCoordinator(rootViewController: sendAppreciationViewController, dependencies: dependencies)
        coordinator.navigationDelegate = self
        addChild(coordinator)
        coordinator.start()
    }
    
    public func didFinishAppreciating() {
        parent?.childDidFinish(self)
    }
    
}

// MARK: - BuyTokensCoordinator Delegate

extension SendAppreciationCoordinator: BuyTokensCoordinatorNavigationDelegate {
    public func buyTokensCoordinatorDismiss(with outcome: IAPManager.TransactionOutcome) {
        switch outcome {
        case .success: viewModel.didCompletePurchase()
        case .failed: viewModel.didFailPurchase()
        case .cancelled: viewModel.didCancelPurchase()
        }
    }
}
