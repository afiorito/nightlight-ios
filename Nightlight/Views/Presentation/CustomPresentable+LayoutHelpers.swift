import UIKit

extension CustomPresentable where Self: UIViewController {
    typealias PresentableTargetFrame = (start: CGRect, end: CGRect)
    
    /// The container view of the presentation.
    var containerView: UIView? {
        return presentationController?.containerView
    }
    
    /// The container size of the presentation.
    var containerSize: CGSize {
        return containerView?.bounds.size ?? UIScreen.main.bounds.size
    }
    
    /// The safe area insets for the presentation container.
    var safeAreaInsets: UIEdgeInsets {
        return view.window?.safeAreaInsets ?? containerView?.safeAreaInsets ?? view.safeAreaInsets
    }
    
    /// The target frame of the presented view.
    var targetFrame: CGRect {
        let targetSize = CGSize(width: width, height: height)
        
        let targetX: CGFloat
        switch frame.origin.x {
        case .left: targetX = insets.left + (ignoresSafeAreaInsets ? 0 : safeAreaInsets.left)
        case .right: targetX = containerSize.width - targetSize.width - insets.right - (ignoresSafeAreaInsets ? 0 : safeAreaInsets.right)
        case .center: targetX = (containerSize.width - targetSize.width) / 2
        }
        
        let targetY: CGFloat
        switch frame.origin.y {
        case .top: targetY = insets.top + (ignoresSafeAreaInsets ? 0 : safeAreaInsets.top)
        case .bottom: targetY = containerSize.height - targetSize.height - insets.bottom - (ignoresSafeAreaInsets ? 0 : safeAreaInsets.bottom)
        case .center: targetY = (containerSize.height - targetSize.height) / 2
        }

        return CGRect(origin: CGPoint(x: targetX, y: targetY), size: targetSize)
    }
    
    /// The target width of the presented view.
    var width: CGFloat {
        let targetWidth: CGFloat

        switch frame.size.width {
        case .max:
            targetWidth = containerSize.width
        case .content(let width):
            targetWidth = width
        case .square:
            guard frame.size.height != .square else {
                preconditionFailure("Both width and height can not have a presentable size of .square")
            }
            
            targetWidth = height
        case .intrinsic:
            if frame.size.height != .square {
                view.frame.size.height = height
            }

            view.layoutIfNeeded()
            
            let targetHeight: CGFloat
            
            switch frame.size.height {
            case .intrinsic: targetHeight = UIView.layoutFittingCompressedSize.height
            case .square: targetHeight = containerSize.height
            default: targetHeight = height
            }
            
            let targetSize = CGSize(width: UIView.layoutFittingCompressedSize.width, height: targetHeight)
            let intrinsicWidth = view.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: .fittingSizeLevel, verticalFittingPriority: .required).width
            
            targetWidth = intrinsicWidth
        }
        
        return min(targetWidth, containerSize.width - (insets.left + insets.right))
    }
    
    /// The target height of the presented view.
    var height: CGFloat {
        let targetHeight: CGFloat

        switch frame.size.height {
        case .max:
            targetHeight = containerSize.height
        case .content(let height):
            targetHeight = height
        case .square:
            guard frame.size.width != .square else {
                preconditionFailure("Both height and width can not have a presentable size of .square")
            }
            
            targetHeight = width
        case .intrinsic:
            if frame.size.width != .square {
                view.frame.size.width = width
            }

            view.layoutIfNeeded()
            
            let targetWidth: CGFloat
            
            switch frame.size.width {
            case .intrinsic: targetWidth = UIView.layoutFittingCompressedSize.width
            case .square: targetWidth = containerSize.width
            default: targetWidth = width
            }
            
            let targetSize = CGSize(width: targetWidth, height: UIView.layoutFittingCompressedSize.height)
            let intrinsicHeight = view.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel).height
            
            targetHeight = intrinsicHeight
        }
        
        return min(targetHeight, containerSize.height - (insets.top + insets.bottom))
    }

}
