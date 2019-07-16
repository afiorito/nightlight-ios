import UIKit

public class NLTabBarController: UITabBarController {
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        addDidChangeThemeObserver()
        
        tabBar.isTranslucent = false
        tabBar.clipsToBounds = true
        
        updateColors(for: theme)
    }
    
    deinit {
        removeDidChangeThemeObserver()
    }
}

// MARK: - Themeable

extension NLTabBarController: Themeable {
    public func updateColors(for theme: Theme) {
        tabBar.barTintColor = .alternateBackground(for: theme)
        tabBar.unselectedItemTintColor = .accent(for: theme)
        tabBar.tintColor = .primaryGrayScale(for: theme)
    }
}
