import UIKit

public protocol ModalPresentable: class {
    var panScrollable: UIScrollView? { get }
    
    var height: ModalHeight { get }
    
    var sideMargins: CGFloat { get }
    
    var cornerRadius: CGFloat { get }
    
    var backgroundAlpha: CGFloat { get }
    
    var transitionDuration: TimeInterval { get }
    
    var animationOptions: UIView.AnimationOptions { get }
}
