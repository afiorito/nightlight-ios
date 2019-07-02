import UIKit

public class PageControl: UIPageControl, Themeable {

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func updateColors(for theme: Theme) {
        pageIndicatorTintColor = .accent(for: theme)
        currentPageIndicatorTintColor = .primaryGrayScale(for: theme)
    }
}
