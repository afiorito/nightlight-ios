import UIKit

/// A constant for representing the height of a modal.
public enum ModalHeight: Equatable {
    
    // Sets the height to be the maximum height (- 2*margins)
    case maxHeight
    
    // Sets the height to be the specified content height
    case contentHeight(CGFloat)
    
    // Sets the height equal to the width of the modal.
    case square
    
    // Sets the height to be the intrinsic content height
    case intrinsicHeight
}
