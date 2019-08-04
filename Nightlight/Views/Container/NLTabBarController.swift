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
    
    func removeBadge() {
        tabBar.subview(ofType: BadgeView.self)?.removeFromSuperview()
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
