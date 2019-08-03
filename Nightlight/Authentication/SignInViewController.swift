import UIKit

public class SignInViewController: UIViewController {
    private let viewModel: SignInViewModel
    
    private var signInView: SignInView {
        return view as! SignInView
    }
    
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
    
    @objc private func signInTapped() {
        let credentials = SignInCredentials(
            username: signInView.username,
            password: signInView.password
        )
        
        signInView.authButton.isLoading = true
        signInView.authButton.isEnabled = false
        
        viewModel.signIn(with: credentials) { [unowned self] (result) in
            self.signInView.authButton.isLoading = false
            self.signInView.authButton.isEnabled = true
            
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
    
    @objc private func signUpTapped(gesture: UITapGestureRecognizer) {
        delegate?.signInViewControllerDidTapSignUp(self)
    }
}

extension SignInViewController: Themeable {
    var theme: Theme {
        return viewModel.theme
    }

    public func updateColors(for theme: Theme) {
        signInView.updateColors(for: theme)
    }
}
