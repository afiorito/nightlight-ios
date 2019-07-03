import UIKit

public class SignUpViewController: UIViewController {
    public typealias Dependencies = StyleManaging
    
    private let dependencies: Dependencies
    
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
        view = SignUpView()
    }
    
    public func updateColors(for theme: Theme) {
        (view as? AuthView)?.updateColors(for: theme)
    }
    
}
