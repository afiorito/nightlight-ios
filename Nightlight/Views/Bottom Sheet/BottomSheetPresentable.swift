import UIKit

/// Defines the options for a view controller being presented as a bottom sheet.
public protocol BottomSheetPresentable: class {
    /// A scroll view embedded in a view controller.
    var panScrollable: UIScrollView? { get }
    
    /// The offset between the top of the screen and top of the bottom sheet.
    var topOffset: CGFloat { get }
    
    /// The height of the bottom sheet.
    var bottomSheetHeight: BottomSheetHeight { get }
    
    /// The corner radius for the top corners of the bottom sheet.
    var cornerRadius: CGFloat { get }
    
    /// The alpha of the background behind the bottom sheet.
    var backgroundAlpha: CGFloat { get }
    
    /// The value used to set the speed of the transition animation.
    var transitionDuration: TimeInterval { get }
    
    /// The value used to determine the amount of bottom when transitioning.
    var springDamping: CGFloat { get }
    
    /// The animation options used when performing animations on the bottom sheet.
    var animationOptions: UIView.AnimationOptions { get }
}
