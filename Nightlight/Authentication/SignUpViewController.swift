import UIKit

/// A view controller for managing sign up.
public class SignUpViewController: UIViewController {
    /// The viewModel for handling state.
    private let viewModel: SignUpViewModel
    
    /// The delegate for managing UI actions.
    public weak var delegate: SignUpViewControllerDelegate?
    
    public var signUpView: SignUpView {
        return view as! SignUpView
    }
    
    init(viewModel: SignUpViewModel) {
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
            guard let self = self else { return }
            self.delegate?.signUpViewController(self, didTapPolicyWith: url)
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
        let credentials = SignUpCredentials(
            username: signUpView.username,
            email: signUpView.email,
            password: signUpView.password
        )
        
        signUpView.authButton.isLoading = true
        
        viewModel.signUp(with: credentials) { [unowned self] (result) in
            
            switch result {
            case .success:
                self.delegate?.signUpViewControllerDidSignUp(self)
            case .failure(let error):
                self.signUpView.authButton.isLoading = false
                switch error {
                case .validation(let reasons):
                    self.signUpView.showFieldErrors(reasons: reasons)
                default:
                    self.showToast("Could not connect to Nightlight.", severity: .urgent)
                }
            }
        }
    }
    
    @objc private func signInTapped() {
        delegate?.signUpViewControllerDidTapSignIn(self)
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
