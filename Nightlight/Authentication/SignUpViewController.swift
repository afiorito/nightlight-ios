import UIKit

/// A view controller for managing sign up.
public class SignUpViewController: UIViewController {
    /// The viewModel for handling state.
    private let viewModel: SignUpViewModel
    
    /// The view that the `SignUpViewController` manages.
    public var signUpView: SignUpView {
        return view as! SignUpView
    }
    
    public init(viewModel: SignUpViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        removeDidChangeThemeObserver()
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        addDidChangeThemeObserver()
        
        signUpView.actionButton.addTarget(self, action: #selector(signInTapped), for: .touchUpInside)
        signUpView.authButton.addTarget(self, action: #selector(signUpTapped), for: .touchUpInside)
        
        updateColors(for: theme)
    }
    
    public override func loadView() {
        let signUpView = SignUpView()
        signUpView.policyAction = { [weak self] url in
            self?.viewModel.selectPolicy(with: url)
        }
        view = signUpView
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
    }
    
    public override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        signUpView.headerBackground.setNeedsDisplay()
    }
    
    /**
    Handle a sign up tap event.
    */
    @objc private func signUpTapped() {
        viewModel.signUp(with: SignUpCredentials(username: signUpView.username, email: signUpView.email, password: signUpView.password))
    }
    
    @objc private func signInTapped() {
        viewModel.signIn()
    }
    
}

// MARK: - SignUpViewModel UI Delegate

extension SignUpViewController: AuthViewModelUIDelegate {
    public func didBeginAuthenticating() {
        signUpView.authButton.isLoading = true
    }
    
    public func didEndAuthenticating() {
        signUpView.authButton.isLoading = false
    }
    
    public func didFailToAuthenticate(with error: AuthError) {
        switch error {
        case .validation(let reasons):
            self.signUpView.showFieldErrors(reasons: reasons)
        default:
            self.showToast(Strings.error.couldNotConnect, severity: .urgent)
        }
    }
    
    public func clearFields() {
        [signUpView.usernameField, signUpView.emailField, signUpView.passwordField].forEach {
            $0.input.text = ""
            $0.error = nil
        }
    }
}

// MARK: - Themeable

extension SignUpViewController: Themeable {
    var theme: Theme {
        return viewModel.theme
    }

    public func updateColors(for theme: Theme) {
        signUpView.updateColors(for: theme)
    }
}
