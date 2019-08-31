import UIKit

/// The main tab bar controller for the application.
public class NLTabBarController: UITabBarController {
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        addDidChangeThemeObserver()
        
        tabBar.isTranslucent = false
        tabBar.clipsToBounds = true
        
        updateColors(for: theme)
    }
    
    /**
     Add a small notification badge to a tab bar item at a specified index.
     
     - parameter index: the index of the tab bar item.
     */
    func addBadge(at index: Int) {
        removeBadge()
        
        let radius: CGFloat = 5
        let topMargin: CGFloat = 8

        guard let itemCount = self.tabBar.items?.count else {
            return
        }

        let itemWidth = self.view.bounds.width / CGFloat(itemCount)
        let xPos = (itemWidth / 2) * CGFloat(index * 2 + 1)

        let redDot = BadgeView(frame: CGRect(x: xPos + 4, y: topMargin, width: radius * 2, height: radius * 2))
        redDot.backgroundColor = .urgent
        redDot.layer.cornerRadius = radius

        tabBar.addSubview(redDot)
    }
    
    /**
     Remove an existing badge for the tab bar.
     */
    func removeBadge() {
        tabBar.subview(ofType: BadgeView.self)?.removeFromSuperview()
    }
    
    deinit {
        removeDidChangeThemeObserver()
    }
}

// MARK: - Themeable

extension NLTabBarController: Themeable {
    public func updateColors(for theme: Theme) {
        if theme != .system {
            tabBar.barTintColor = .secondaryBackground(for: theme)
            tabBar.unselectedItemTintColor = .accent(for: theme)
        } else {
            tabBar.barTintColor = nil
            tabBar.unselectedItemTintColor = nil
        }
        tabBar.tintColor = .invertedBackground(for: theme)
    }
}
