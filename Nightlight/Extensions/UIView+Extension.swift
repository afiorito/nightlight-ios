import UIKit

extension UIView {
    /**
     Add views to the end of the receiver’s list of subviews.
     
     - parameter views: The views to be added. After being added, the views appear on top of other subviews.
     - parameter shouldTranslateAutoresizeMask: sets translatesAutoresizingMaskIntoConstraints to the specified value.
     */
    public func addSubviews(_ views: [UIView], shouldTranslateAutoresizeMask: Bool = true) {
        views.forEach {
            if shouldTranslateAutoresizeMask {
                $0.translatesAutoresizingMaskIntoConstraints = false
            }
            self.addSubview($0)
        }
    }
    
    /**
     Add views to the end of the receiver’s list of subviews.
     
     - parameter views: The views to be added. After being added, the views appear on top of other subviews.
     - parameter shouldTranslateAutoresizeMask: sets translatesAutoresizingMaskIntoConstraints to the specified value.
     */
    public func addSubviews(_ views: UIView..., shouldTranslateAutoresizeMask: Bool = true) {
        self.addSubviews(views, shouldTranslateAutoresizeMask: shouldTranslateAutoresizeMask)
    }
}
