import UIKit

extension UIStackView {
    /**
     Adds a view to the end of the arrangedSubviews array.
     
     - parameter views: The views to be added to the array of views arranged by the stack.
     - parameter shouldTranslateAutoresizeMask: sets translatesAutoresizingMaskIntoConstraints to specified value.
     
     */
    public func addArrangedSubviews(_ views: [UIView], shouldTranslateAutoresizeMask: Bool = true) {
        views.forEach {
            if shouldTranslateAutoresizeMask {
                $0.translatesAutoresizingMaskIntoConstraints = false
            }
            self.addArrangedSubview($0)
        }
    }
    
    /**
     Adds a view to the end of the arrangedSubviews array.
     
     - parameter views: The views to be added to the array of views arranged by the stack.
     - parameter shouldTranslateAutoresizeMask: sets translatesAutoresizingMaskIntoConstraints to specified value.
     
     */
    public func addArrangedSubviews(_ views: UIView..., shouldTranslateAutoresizeMask: Bool = false) {
        self.addSubviews(views, shouldTranslateAutoresizeMask: shouldTranslateAutoresizeMask)
    }
}
