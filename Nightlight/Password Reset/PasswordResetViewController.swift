import UIKit

/// A view controller for managing password reset.
public class PasswordResetViewController: UIViewController {
    /// A constant to denote the step of the password reset process.
    public enum Step: Int, Comparable {
        case requestEmail
        case goToEmail
        case resetPassword

        public static func < (lhs: PasswordResetViewController.Step, rhs: PasswordResetViewController.Step) -> Bool {
            return lhs.rawValue < rhs.rawValue
        }
    }
    /// The viewModel for handling state.
    private let viewModel: PasswordResetViewModel
    
    /// The reset password token.
    public var token: String? {
        didSet {
            if token != nil && currentStep.value != .resetPassword {
                goToStep(.resetPassword)
            }
        }
    }
    
    /// The current step of the reset password process.
    var currentStep: (value: Step, view: UIView?)
    
    public init(step: Step, viewModel: PasswordResetViewModel) {
        self.currentStep = (value: step, view: nil)
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
        goToStep(step)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        headerView.cancelAction = { [weak self] in
            self?.dismiss(animated: true)
        }
        
        prepareSubviews()
        updateColors(for: theme)
    }
    
    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        if isBeingRemoved {
            viewModel.finish()
        }
    }
    
    /// A view for displaying header information.
    public let headerView: HeaderBarView = {
        let headerView = HeaderBarView()
        headerView.titleLabel.text = Strings.passwordReset
        
        return headerView
    }()
    
    private func prepareSubviews() {
        view.addSubviews([headerView])
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func prepareStepView(_ step: Step) -> UIView {
        let stepView: UIView

        switch step {
        case .requestEmail:
            let requestEmailView = RequestEmailView()
            requestEmailView.sendResetEmailAction = { [weak self] email in
                self?.viewModel.sendPasswordResetEmail(to: email)
            }
            stepView = requestEmailView
        case .goToEmail:
            stepView = EmptyView(description: EmptyViewDescription(title: "Reset Email Sent!", subtitle: "Check your inbox for the password reset link.", imageName: "empty_message"))
        case .resetPassword:
            let resetPasswordView = ResetPasswordView()
            resetPasswordView.resetPasswordAction = { [weak self] password in
                if let token = self?.token {
                    self?.viewModel.resetPassword(password, token: token)
                }
            }
            stepView = resetPasswordView
        }
        
        return stepView
    }
    
    /**
     Go to the specified step in the password reset process.
     
     - parameter step: The step to go to next.
     */
    private func goToStep(_ step: Step) {
        let stepView = prepareStepView(step)

        guard currentStep.view != nil else {
            return addStepView(stepView)
        }
        
        // The steps only go in the forward direction
        guard step > currentStep.value else { return }
        
        let disappearTransform = CGAffineTransform(translationX: -view.frame.width, y: 0)
        let appearTransform = CGAffineTransform(translationX: view.frame.width, y: 0)
        
        let previousStepView = currentStep.view
        stepView.transform = appearTransform
        addStepView(stepView)
        
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.0, options: [], animations: {
            previousStepView?.transform = disappearTransform
            stepView.transform = .identity
        }, completion: { _ in
            previousStepView?.removeFromSuperview()
        })
    }
    
    /**
     Add the current step view to it's superview
     
     - parameter stepView: The current step view.
     */
    private func addStepView(_ stepView: UIView) {
        currentStep.view = stepView
        view.addSubviews(stepView)
        (stepView as? Themeable)?.updateColors(for: theme)
        
        NSLayoutConstraint.activate([
            stepView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stepView.leadingAnchor.constraint(equalTo: view.readableContentGuide.leadingAnchor),
            stepView.trailingAnchor.constraint(equalTo: view.readableContentGuide.trailingAnchor)
        ])
    }
    
    override public var preferredStatusBarStyle: UIStatusBarStyle {
        switch theme {
        case .dark:
            return .lightContent
        case .light:
            if #available(iOS 13.0, *) {
                return .darkContent
            } else {
                return .default
            }
        case .system:
            return .default
        }
    }
}

// MARK: - PasswordResetViewModel UI Delegate

extension PasswordResetViewController: PasswordResetViewModelUIDelegate {
    public func didBeginSendingResetEmail() {
        guard let requestEmailView = currentStep.view as? RequestEmailView else { return }
        
        requestEmailView.confirmButton.isLoading = true
        
    }
    
    public func didSendResetEmail() {
        goToStep(.goToEmail)
    }
    
    public func didEndSendingResetEmail() {
        guard let requestEmailView = currentStep.view as? RequestEmailView else { return }

        requestEmailView.confirmButton.isLoading = false
    }
    
    public func didFailSendingResetEmail(with error: AuthError) {
        guard let requestEmailView = currentStep.view as? RequestEmailView else { return }
        
        if case let .validation(reasons) = error {
            if reasons.first(where: { $0.property == "email" }) != nil {
                requestEmailView.emailField.error = Strings.auth.invalidEmail
            }
        } else {
            showToast(Strings.error.couldNotConnect, severity: .urgent)
        }
    }
    
    public func didBeginResetingPassword() {
        guard let resetPasswordView = currentStep.view as? ResetPasswordView else { return }
        
        resetPasswordView.confirmButton.isLoading = true
        
    }
    
    public func didFailResettingPassword(with error: AuthError) {
        guard let resetPasswordView = currentStep.view as? ResetPasswordView else { return }

        if case let .validation(reasons) = error {
            if reasons.first(where: { $0.property == "password" }) != nil {
                resetPasswordView.newPasswordField.error = Strings.auth.weakPassword
            }
        } else {
            showToast(Strings.error.couldNotConnect, severity: .urgent)
        }
    }
    
    public func didEndResettingPassword() {
        guard let resetPasswordView = currentStep.view as? ResetPasswordView else { return }
        resetPasswordView.confirmButton.isLoading = false
    }

}

// MARK: - Themeable

extension PasswordResetViewController: Themeable {
    func updateColors(for theme: Theme) {
        view.backgroundColor = .background(for: theme)
        headerView.updateColors(for: theme)
    }
}
