import UIKit

public class MainNavigationController: UINavigationController, Themeable {
    public typealias Dependencies = StyleManaging

    private let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        addDidChangeThemeObserver()
        
        updateColors(for: dependencies.styleManager.theme)
    }
    
    deinit {
        removeDidChangeThemeObserver()
    }

    override public func show(_ vc: UIViewController, sender: Any?) {
        vc.navigationItem.titleView = {
            let label = UILabel(frame: CGRect(x: 15.0, y: 0.0, width: view.frame.width - 30, height: 30.0))
            label.text = vc.title
            label.font = .primary24ptBold
            return label
        }()
        
        updateNavigationItemColors(for: vc, using: dependencies.styleManager.theme)
        
        super.show(vc, sender: sender)
    }
    
    private func updateNavigationItemColors(for viewController: UIViewController, using theme: Theme) {
        if let titleLabel = viewController.navigationItem.titleView as? UILabel {
            titleLabel.textColor = .primaryText(for: theme)
        }
    }
    
    public func updateColors(for theme: Theme) {
        navigationBar.isTranslucent = false
        navigationBar.barTintColor = .background(for: theme)
        navigationBar.shadowImage = UIColor.border(for: theme).asImage()

        for vc in viewControllers {
            updateNavigationItemColors(for: vc, using: theme)
        }
    }

    override public var preferredStatusBarStyle: UIStatusBarStyle {
        switch dependencies.styleManager.theme {
        case .light:
            if #available(iOS 13.0, *) {
                return .darkContent
            } else {
                return .default
            }
        case .dark:
            return .lightContent
        }
    }
}
