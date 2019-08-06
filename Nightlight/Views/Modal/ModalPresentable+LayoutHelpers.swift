import UIKit

extension ModalPresentable where Self: UIViewController {
    var presentationController: ModalPresentationController? {
        return presentationController as? ModalPresentationController
    }
    
    var targetSize: CGSize {
        return CGSize(width: targetWidth, height: targetHeight)
    }
    
    var targetWidth: CGFloat {
        return containerBounds.width - 2 * sideMargins
    }
    
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
    
    var intrinsicHeight: CGFloat {
        view.layoutIfNeeded()

        let targetSize = CGSize(width: containerBounds.width, height: UIView.layoutFittingCompressedSize.height)
        return view.systemLayoutSizeFitting(targetSize).height
    }
    
    var containerBounds: CGRect {
        guard let container = presentationController?.containerView
            else { return view.bounds }
        
        return container.bounds
    }
}
