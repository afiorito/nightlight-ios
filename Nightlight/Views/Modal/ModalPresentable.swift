import UIKit

/// Defines the options for a view controller being presented as a modal.
public protocol ModalPresentable: class {
    /// The height of the modal.
    var height: ModalHeight { get }
    
    /// The spacing between the left and right sides of the modal.
    var sideMargins: CGFloat { get }
    
    /// The corner radius for the corners of the modal.
    var cornerRadius: CGFloat { get }
    
    /// The alpha of the background behind the modal.
    var backgroundAlpha: CGFloat { get }
    
    /// The value used to set the speed of the transition animation.
    var transitionDuration: TimeInterval { get }
    
    /// The animation options used when performing animations on the bottom sheet.
    var animationOptions: UIView.AnimationOptions { get }
}
