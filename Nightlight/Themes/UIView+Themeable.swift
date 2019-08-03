import UIKit

extension Themeable where Self: UIView {
    var theme: Theme {
        return StyleManager.default.theme
    }
    
    func updateColors(for theme: Theme) {}
}
