import UIKit

public class SignInViewController: UIViewController, Themeable {
    public typealias Dependencies = StyleManaging
    
    private let dependencies: Dependencies
    
    private var signInView: SignInView {
        return view as! SignInView
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
        
        updateColors(for: dependencies.styleManager.theme)
    }
    
    public override func loadView() {
        view = SignInView()
    }
    
    public func updateColors(for theme: Theme) {
        signInView.updateColors(for: theme)
    }
    
}
