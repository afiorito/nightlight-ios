import UIKit

/// A view controller for managing sign in.
public class SignInViewController: UIViewController {
    /// The viewModel for handling state.
    private let viewModel: SignInViewModel
    
    /// The view that the `SignInViewController` manages.
    private var signInView: SignInView {
        return view as! SignInView
    }
    
    public init(viewModel: SignInViewModel) {
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
        
        signInView.actionButton.addTarget(self, action: #selector(signUpTapped), for: .touchUpInside)
        signInView.authButton.addTarget(self, action: #selector(signInTapped), for: .touchUpInside)
        
        updateColors(for: self.theme)
    }
    
    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        view.endEditing(true)
        clearFields()
    }
    
    public override func loadView() {
        view = SignInView()
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    public override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        signInView.headerBackground.setNeedsDisplay()
    }
    
    /**
     Handle a sign in tap event.
     */
    @objc private func signInTapped() {
        viewModel.signIn(with: SignInCredentials(username: signInView.username, password: signInView.password))
    }
    
    /**
     Handle a sign up tap event.
     */
    @objc private func signUpTapped(gesture: UITapGestureRecognizer) {
        viewModel.signUp()
    }
}

// MARK: - SignInViewModel UI Delegate

extension SignInViewController: AuthViewModelUIDelegate {
    public func didBeginAuthenticating() {
        signInView.authButton.isLoading = true
    }
    
    public func didEndAuthenticating() {
        signInView.authButton.isLoading = false
    }
    
    public func didFailToAuthenticate(with error: AuthError) {
        switch error {
        case .validation(let reasons):
            self.showToast(Strings.auth.failedSignIn, severity: .urgent)
            self.signInView.showFieldErrors(reasons: reasons)
        default:
            self.showToast(Strings.error.couldNotConnect, severity: .urgent)
        }
    }
    
    public func clearFields() {
        [signInView.usernameField, signInView.passwordField].forEach {
            $0.input.text = nil
            $0.error = nil
        }
    }
}

// MARK: - Themeable

extension SignInViewController: Themeable {
    var theme: Theme {
        return viewModel.theme
    }

    public func updateColors(for theme: Theme) {
        signInView.updateColors(for: theme)
    }
}
