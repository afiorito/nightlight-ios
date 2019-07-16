import UIKit

public protocol BottomSheetPresentable: class {
    var panScrollable: UIScrollView? { get }
    
    var topOffset: CGFloat { get }
    
    var height: BottomSheetHeight { get }
    
    var cornerRadius: CGFloat { get }
    
    var backgroundAlpha: CGFloat { get }
    
    var transitionDuration: TimeInterval { get }
    
    var springDamping: CGFloat { get }
    
    var animationOptions: UIView.AnimationOptions { get }
}
