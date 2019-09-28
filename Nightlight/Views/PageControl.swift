import UIKit

/// A page control with styling.
public class PageControl: UIPageControl {}

extension PageControl: Themeable {
    public func updateColors(for theme: Theme) {
        pageIndicatorTintColor = UIColor.label(for: theme).withAlphaComponent(0.3)
        currentPageIndicatorTintColor = .label(for: theme)
    }
}
