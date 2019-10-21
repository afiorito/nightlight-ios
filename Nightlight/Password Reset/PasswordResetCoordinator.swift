import UIKit

/// A coordinator for password reset flow.
public class PasswordResetCoordinator: Coordinator {
    public typealias Dependencies = StyleManaging
    public weak var parent: Coordinator?
    public var children = [Coordinator]()
    
    /// The required dependencies.
    private let dependencies: Dependencies
    
    public init(rootViewController: UIViewController, dependencies: Dependencies, token: String? = nil) {
        self.rootViewController = rootViewController
        self.dependencies = dependencies
        
        let viewModel = PasswordResetViewModel(dependencies: dependencies as! PasswordResetViewModel.Dependencies)
        if let token = token {
            self.passwordResetViewController = PasswordResetViewController(step: .resetPassword, viewModel: viewModel)
            passwordResetViewController.token = token
        } else {
            self.passwordResetViewController = PasswordResetViewController(step: .requestEmail, viewModel: viewModel)
        }

        viewModel.uiDelegate = self.passwordResetViewController
        viewModel.navigationDelegate = self
    }
    
    /// The root view controller of password reset view controller.
    private let rootViewController: UIViewController
    
    /// The view controller used to sign in a user.
    private let passwordResetViewController: PasswordResetViewController

    public func start() {
        if UIDevice.current.userInterfaceIdiom == .pad {
            passwordResetViewController.modalPresentationStyle = .formSheet
        } else {
            passwordResetViewController.modalPresentationStyle = .fullScreen
        }
        
        rootViewController.present(passwordResetViewController, animated: true)
    }
}

// MARK: - PasswordReset Navigation Delegate

extension PasswordResetCoordinator: PasswordResetNavigationDelegate {
    public func didFailResettingPassword() {
        rootViewController.dismiss(animated: true) { [weak self] in
            self?.rootViewController.showToast(Strings.error.invalidResetLink, severity: .urgent)
        }
    }
    
    public func didResetPassword() {
        rootViewController.dismiss(animated: true) { [ weak self] in
            self?.rootViewController.showToast(Strings.passwordResetSuccessfully, severity: .success)
        }
    }
    
    public func didStopResettingPassword() {
        parent?.childDidFinish(self)
    }
    
}
