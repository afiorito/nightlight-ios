import UIKit

/// The main tab bar controller for the application.
public class NLTabBarController: UITabBarController {
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        addDidChangeThemeObserver()
        
        tabBar.isTranslucent = false
        
        updateColors(for: theme)
    }
    
    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        if #available(iOS 13, *), traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            updateColors(for: theme)
        }
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
        tabBar.barTintColor = .background(for: theme)
        tabBar.unselectedItemTintColor = .gray(for: theme)
        if #available(iOS 13, *) {
           let appearance = self.tabBar.standardAppearance.copy()
           appearance.backgroundImage = UIColor.background(for: theme).asImage()
           appearance.shadowImage = UIColor.secondaryLabel(for: theme).withAlphaComponent(0.3).asImage(with: CGSize(width: 1, height: 1 / UIScreen.main.scale))
           self.tabBar.standardAppearance = appearance
        } else {
            tabBar.backgroundImage = UIColor.background(for: theme).asImage()
            tabBar.shadowImage = UIColor.secondaryLabel(for: theme).withAlphaComponent(0.3).asImage(with: CGSize(width: 1, height: 1 / UIScreen.main.scale))
        }
        tabBar.tintColor = .label(for: theme)
        tabBar.layoutIfNeeded()
    }
}
