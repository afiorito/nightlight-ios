import UIKit

extension UITabBar {
    func badgeViewForItem(at index: Int) -> UIView? {
        guard subviews.count > index else {
            return nil
        }
        
        return subviews[index + 1].subviews.first(where: { NSStringFromClass($0.classForCoder) == "_UIBadgeView" })
    }
}
