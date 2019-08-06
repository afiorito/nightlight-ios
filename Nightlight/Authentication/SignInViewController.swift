import UIKit

/// A view controller for managing sign in.
public class SignInViewController: UIViewController {
    /// The viewModel for handling state.
    private let viewModel: SignInViewModel
    
    private var signInView: SignInView {
        return view as! SignInView
    }
    
    /// The delegate for managing UI actions.
    public weak var delegate: SignInViewControllerDelegate?
    
    init(viewModel: SignInViewModel) {
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
    
    public override func loadView() {
        view = SignInView()
    }
    
    /**
     Handle a sign in tap event.
     */
    @objc private func signInTapped() {
        let credentials = SignInCredentials(
            username: signInView.username,
            password: signInView.password
        )
        
        signInView.authButton.isLoading = true
        
        viewModel.signIn(with: credentials) { [unowned self] (result) in
            self.signInView.authButton.isLoading = false
            
            switch result {
            case .success:
                self.delegate?.signInViewControllerDidSignIn(self)
            case .failure(let error):
                switch error {
                case .validation(let reasons):
                    self.showToast("Username or password are incorrect.", severity: .urgent)
                    self.signInView.showFieldErrors(reasons: reasons)
                default:
                    self.showToast("Could not connect to Nightlight.", severity: .urgent)
                }
            }
        }
    }
    
    /**
     Handle a sign up tap event.
     */
    @objc private func signUpTapped(gesture: UITapGestureRecognizer) {
        delegate?.signInViewControllerDidTapSignUp(self)
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
