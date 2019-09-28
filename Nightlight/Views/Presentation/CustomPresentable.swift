import UIKit

/// Defines the options for a view controller being presented using a custom transition.
public protocol CustomPresentable: class {
    /// The size of the presented view.
    var frame: CustomPresentableFrame { get }
    
    /// The spacing between the sides of the presented view.
    var insets: UIEdgeInsets { get }
    
    /// The corner radius for the presented view.
    var cornerRadius: CGFloat { get }
    
    /// The alpha of the background view behind the presented view.
    ///
    /// A value of 0.0 results in no background view.
    var backgroundAlpha: CGFloat { get }
    
    /// A boolean denoting if safe area insets are included when laying out the presented view.
    var ignoresSafeAreaInsets: Bool { get }
}
