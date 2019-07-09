import UIKit

public class SignUpViewController: UIViewController {
    public typealias Dependencies = StyleManaging
    
    private let viewModel: SignUpViewModel
    
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
        
        updateColors(for: viewModel.theme)
    }
    
    public override func loadView() {
        view = SignUpView()
        
    }
    
    @objc private func signUpTapped() {
        let credentials = SignUpCredentials(
            username: signUpView.username,
            email: signUpView.email,
            password: signUpView.password
        )
        
        signUpView.authButton.isLoading = true
        
        viewModel.signup(with: credentials) { [unowned self] (result) in
            self.signUpView.authButton.isLoading = false
            
            switch result {
            case .success:
                self.delegate?.signUpViewControllerDidSignUp(self)
            case .failure(let error):
                switch error {
                case .validation(let reasons):
                    self.signUpView.showFieldErrors(reasons: reasons)
                default:
                    let toast = self.showToast("Something went wrong.", severity: .urgent)
                    toast.updateColors(for: self.viewModel.theme)
                }
            }
        }
    }
    
    @objc private func signInTapped() {
        delegate?.signUpViewControllerDidTapSignIn(self)
    }
    
    public func updateColors(for theme: Theme) {
        (view as? AuthView)?.updateColors(for: theme)
    }
    
}
