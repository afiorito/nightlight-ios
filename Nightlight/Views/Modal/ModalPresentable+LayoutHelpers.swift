import UIKit

extension ModalPresentable where Self: UIViewController {
    /// A reference of the presentation controller as a BottomSheetPresentationController so we can access properties and methods.
    var presentationController: ModalPresentationController? {
        return presentationController as? ModalPresentationController
    }
    
    /// The target size of the modal.
    var targetSize: CGSize {
        return CGSize(width: targetWidth, height: targetHeight)
    }
    
    /// The target width of modal including margins.
    var targetWidth: CGFloat {
        return containerBounds.width - 2 * sideMargins
    }
    
    /// The target height of the modal.
    var targetHeight: CGFloat {
        switch height {
        case .maxHeight:
            return containerBounds.height - 2 * sideMargins
        case .contentHeight(let height):
            return height
        case .square:
            // the content may not be able to fit inside a square.
            return max(intrinsicHeight, targetWidth)
        case .intrinsicHeight:
            return intrinsicHeight
        }
    }
    
    /// The intrinsic height of the modal using compressed sizing.
    var intrinsicHeight: CGFloat {
        view.layoutIfNeeded()

        let targetSize = CGSize(width: containerBounds.width, height: UIView.layoutFittingCompressedSize.height)
        return view.systemLayoutSizeFitting(targetSize).height
    }
    
    /// The bounds of the container view of the transition.
    var containerBounds: CGRect {
        guard let container = presentationController?.containerView
            else { return view.bounds }
        
        return container.bounds
    }
}
