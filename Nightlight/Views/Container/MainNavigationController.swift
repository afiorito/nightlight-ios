import UIKit

public class MainNavigationController: UINavigationController {
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        addDidChangeThemeObserver()
        updateColors(for: theme)
    }
    
    deinit {
        removeDidChangeThemeObserver()
    }

    override public func show(_ vc: UIViewController, sender: Any?) {
        vc.navigationItem.titleView = {
            let titleView = UIView(frame: CGRect(x: 15.0, y: 0.0, width: view.frame.width - 30, height: 30.0))
            let label = UILabel(frame: CGRect(x: 0.0, y: 0.0, width: view.frame.width - 30, height: 30.0))
            label.autoresizingMask = [.flexibleTopMargin]
            label.text = vc.title
            label.font = .primary24ptBold
            
            titleView.addSubview(label)
            
            return titleView
        }()
        
        updateNavigationItemColors(for: vc, using: theme)
        
        super.show(vc, sender: sender)
    }
    
    private func updateNavigationItemColors(for viewController: UIViewController, using theme: Theme) {
        if let titleView = viewController.navigationItem.titleView, let label = titleView.subviews.first as? UILabel {
            label.textColor = .primaryText(for: theme)
        }
    }

    override public var preferredStatusBarStyle: UIStatusBarStyle {
        switch theme {
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

// MARK: - Themeable

extension MainNavigationController: Themeable {
    public func updateColors(for theme: Theme) {
        navigationBar.isTranslucent = false
        navigationBar.barTintColor = .background(for: theme)
        navigationBar.shadowImage = UIColor.border(for: theme).asImage()
        navigationBar.tintColor = .primaryGrayScale(for: theme)
        
        for vc in viewControllers {
            updateNavigationItemColors(for: vc, using: theme)
        }
    }
}
