import UIKit

public extension ModalPresentable where Self: UIViewController {
    
    var cornerRadius: CGFloat {
        return 8.0
    }
    
    var height: ModalHeight {
        return .intrinsicHeight
    }
    
    var sideMargins: CGFloat {
        return 15.0
    }
    
    var backgroundAlpha: CGFloat {
        return 0.7
    }
    
    var transitionDuration: TimeInterval {
        return ModalAnimator.defaultDuration
    }
    
    var animationOptions: UIView.AnimationOptions {
        return [.curveEaseInOut, .allowUserInteraction, .beginFromCurrentState]
    }

}
