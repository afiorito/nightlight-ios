import UIKit

extension UIView {
    /**
     Add views to the end of the receiver’s list of subviews.
     
     - parameter views: The views to be added. After being added, the views appear on top of other subviews.
     - parameter shouldTranslateAutoresizeMask: sets translatesAutoresizingMaskIntoConstraints to the specified value.
     */
    public func addSubviews(_ views: [UIView], shouldTranslateAutoresizeMask: Bool = false) {
        views.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = shouldTranslateAutoresizeMask
            self.addSubview($0)
        }
    }
    
    /**
     Add views to the end of the receiver’s list of subviews.
     
     - parameter views: The views to be added. After being added, the views appear on top of other subviews.
     - parameter shouldTranslateAutoresizeMask: sets translatesAutoresizingMaskIntoConstraints to the specified value.
     */
    public func addSubviews(_ views: UIView..., shouldTranslateAutoresizeMask: Bool = false) {
        self.addSubviews(views, shouldTranslateAutoresizeMask: shouldTranslateAutoresizeMask)
    }
    
    public func superview<T>(ofType type: T.Type) -> T? {
        var superview = self.superview
        while superview != nil && (superview as? T) == nil {
            superview = superview?.superview
        }
        
        return superview as? T
    }
    
    public func subview<T>(ofType type: T.Type) -> T? {
        var match: T?

        for view in subviews {
            if let target = view as? T {
                return target
            }
            
            match = view.subview(ofType: type)
        }
        
        return match
    }
    
    public func addShadow(forTheme theme: Theme, shouldRasterize: Bool = true) {
        layoutIfNeeded()
        layer.shadowColor = UIColor.shadow(for: theme).cgColor
        layer.shadowOffset = CGSize(width: 0, height: 1)
        layer.shadowRadius = 4.0
        layer.shadowOpacity = 1.0
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: layer.cornerRadius).cgPath
        layer.shouldRasterize = shouldRasterize
        layer.rasterizationScale = UIScreen.main.scale
    }
}
