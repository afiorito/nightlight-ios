import UIKit

/// A coordinator for account settings flow.
public class AccountSettingsCoordinator: Coordinator {
    public typealias Dependencies = NotificationObserving & StyleManaging
    public weak var parent: Coordinator?
    public var children = [Coordinator]()
        
    /// The required dependencies.
    private let dependencies: Dependencies
        
    /// The root view controller of the settings view controller.
    private let rootViewController: UINavigationController
        
    var simulatedBackButton: UIBarButtonItem {
        return UIBarButtonItem(image: UIImage.icon.back, style: .plain, target: self, action: #selector(pop))
    }
        
    /// The view model for managing the state of the view.
    private lazy var viewModel: AccountSettingsViewModel = {
        AccountSettingsViewModel(dependencies: dependencies as! AccountSettingsViewModel.Dependencies)
    }()
        
    /// A view controller for managing account settings.
    public lazy var accountSettingsViewController: AccountSettingsViewController = {
        let viewController = AccountSettingsViewController(viewModel: viewModel)
        viewController.navigationItem.leftBarButtonItem = simulatedBackButton
        viewController.title = Strings.setting.accountSettingsTitle
        
        viewModel.uiDelegate = viewController
        viewModel.navigationDelegate = self
        
        return viewController
    }()
    
    // A transition for presenting view controllers from below.
    private let bottomTransition = BottomTransition()
        
    public init(rootViewController: UINavigationController, dependencies: Dependencies) {
        self.rootViewController = rootViewController
        self.dependencies = dependencies
    }
    
    public func start() {
        rootViewController.pushViewController(accountSettingsViewController, animated: true)
    }
    
    @objc private func pop() {
        accountSettingsViewController.navigationController?.popViewController(animated: true)
    }
}

// MARK: - Account Settings Navigation Delegate

extension AccountSettingsCoordinator: AccountSettingsNavigationDelegate {
    public func showChangeEmail() {
        let changeEmailViewController = ChangeEmailViewController(viewModel: viewModel)

        changeEmailViewController.modalPresentationStyle = .custom
        changeEmailViewController.transitioningDelegate = bottomTransition
        viewModel.eventDelegate = changeEmailViewController
        
        rootViewController.present(changeEmailViewController, animated: true)
    }
    
    public func showChangePassword() {
        let changePasswordViewController = ChangePasswordViewController(viewModel: viewModel)
        
        changePasswordViewController.modalPresentationStyle = .custom
        changePasswordViewController.transitioningDelegate = bottomTransition
        viewModel.eventDelegate = changePasswordViewController
        
        rootViewController.present(changePasswordViewController, animated: true)
    }
    
    public func didChangeEmail() {
        rootViewController.dismiss(animated: true)
    }
    
    public func didFailChangeEmail() {
        rootViewController.dismiss(animated: true)
    }
    
    public func didFinishViewingAccountSettings() {
        parent?.childDidFinish(self)
    }
    
    public func didChangePassword() {
        rootViewController.dismiss(animated: true)
    }
    
    public func didFailChangePassword() {
        rootViewController.dismiss(animated: true)
    }
}
