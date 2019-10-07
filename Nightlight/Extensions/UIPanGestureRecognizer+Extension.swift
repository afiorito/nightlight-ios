import UIKit

extension UIPanGestureRecognizer {
    public func isFlick(in view: UIView, threshold: CGFloat = 1200) -> Bool {
        let velocity = self.velocity(in: view).vector
        
        return velocity.magnitude > threshold
    }
    
    public func isFlickDown(in view: UIView, threshold: CGFloat = 1200) -> Bool {
        return isFlick(in: view, threshold: threshold) && self.velocity(in: view).y > 0.0
    }
    
    public func isFlickUp(in view: UIView, threshold: CGFloat = 1200) -> Bool {
        return isFlick(in: view, threshold: threshold) && self.velocity(in: view).y < 0.0
    }
    
    public func isFlickLeft(in view: UIView, threshold: CGFloat = 1200) -> Bool {
        return isFlick(in: view, threshold: threshold) && self.velocity(in: view).x < 0.0
    }
    
    public func isFlickRight(in view: UIView, threshold: CGFloat = 1200) -> Bool {
        return isFlick(in: view, threshold: threshold) && self.velocity(in: view).x > 0.0
    }
    
}
