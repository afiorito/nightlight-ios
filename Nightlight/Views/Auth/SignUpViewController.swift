import UIKit

public class SignUpViewController: UIViewController {
    public typealias Dependencies = StyleManaging
    
    private let dependencies: Dependencies
    
    public weak var delegate: SignUpViewControllerDelegate?
    
    public var signUpView: SignUpView {
        return view as! SignUpView
    }
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
        
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
        
        updateColors(for: dependencies.styleManager.theme)
    }
    
    public override func loadView() {
        view = SignUpView()
        
    }
    
    @objc private func signInTapped() {
        delegate?.signUpViewControllerDidTapSignIn(self)
    }
    
    public func updateColors(for theme: Theme) {
        (view as? AuthView)?.updateColors(for: theme)
    }
    
}
