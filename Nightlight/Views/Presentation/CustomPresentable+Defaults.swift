import UIKit

/// The default values for a view controller conforming to `CustomPresentable`.
public extension CustomPresentable where Self: UIViewController {
    var frame: CustomPresentableFrame {
        return CustomPresentableFrame(x: .center, y: .center, width: .max, height: .max)
    }

    var insets: UIEdgeInsets {
        return .zero
    }

    var cornerRadius: CGFloat {
        return 8.0
    }

    var backgroundAlpha: CGFloat {
        return 0.8
    }
    
    var ignoresSafeAreaInsets: Bool {
        return false
    }
}
