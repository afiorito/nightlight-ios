import UIKit

/// A protocol denoting a type that can apply a theme.
protocol Themeable {
    /**
     Called to update colors when theme changes.
     
     - parameter theme: the new theme used to update colors.
     */
    func updateColors(for theme: Theme)
    
}
