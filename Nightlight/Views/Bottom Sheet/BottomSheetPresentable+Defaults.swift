import UIKit

public extension BottomSheetPresentable where Self: UIViewController {
    
    var topOffset: CGFloat {
        return layoutInsets.top + 15
    }
    
    var height: BottomSheetHeight {
        guard let scrollView = panScrollable
            else { return .maxHeight }
        
        return .contentHeight(scrollView.contentSize.height)
    }
    
    var cornerRadius: CGFloat {
        return 8.0
    }
    
    var backgroundAlpha: CGFloat {
        return 0.7
    }
    
    var transitionDuration: TimeInterval {
        return BottomSheetAnimator.defaultDuration
    }
    
    var springDamping: CGFloat {
        return 0.8
    }
    
    var animationOptions: UIView.AnimationOptions {
        return [.curveEaseInOut, .allowUserInteraction, .beginFromCurrentState]
    }

}
