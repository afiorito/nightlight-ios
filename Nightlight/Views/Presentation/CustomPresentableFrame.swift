import UIKit

/// A structure that contains the size and location for a presentable.
public struct CustomPresentableFrame {
    let origin: CustomPresentableOrigin
    let size: CustomPresentableSize
    
    init(origin: CustomPresentableOrigin, size: CustomPresentableSize) {
        self.origin = origin
        self.size = size
    }
    
    init(x: CustomPresentableOrigin.XPosition, y: CustomPresentableOrigin.YPosition, width: CustomPresentableSize.Dimension, height: CustomPresentableSize.Dimension) {
        self.origin = CustomPresentableOrigin(x: x, y: y)
        self.size = CustomPresentableSize(width: width, height: height)
    }
}

/// A structure that contains the width and height of a presentable.
public struct CustomPresentableSize {
    /// A constant for representing the  dimension size of a view presented with a custom transition.
    public enum Dimension: Equatable {
        
        // Sets the dimension to be the maximum size.
        case max
        
        // Sets the dimension to the specified value.
        case content(CGFloat)
        
        // Sets the dimension to be equal to the other dimension.
        case square
        
        // Sets the dimension to the intrinsic size.
        case intrinsic
    }

    let width: Dimension
    let height: Dimension
}

/// a structure that contains the x and y position of a presentable.
public struct CustomPresentableOrigin {
    public enum XPosition {
        case left, right
        case center
    }
    
    public enum YPosition {
        case top, bottom
        case center
    }
    
    let x: XPosition
    let y: YPosition
}
