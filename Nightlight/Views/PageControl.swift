import UIKit

/// A page control with styling.
public class PageControl: UIPageControl {}

extension PageControl: Themeable {
    public func updateColors(for theme: Theme) {
        pageIndicatorTintColor = .accent(for: theme)
        currentPageIndicatorTintColor = .primaryGrayScale(for: theme)
    }
}
