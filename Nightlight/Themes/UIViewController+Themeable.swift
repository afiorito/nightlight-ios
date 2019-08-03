import UIKit

extension Themeable where Self: UIViewController {
    var theme: Theme {
        return StyleManager.default.theme
    }
    
    func updateColors(for theme: Theme) {}
}
