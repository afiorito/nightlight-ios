import UIKit

extension ModalPresentable where Self: UIViewController {
    var presentationController: ModalPresentationController? {
        return presentationController as? ModalPresentationController
    }
    
    var targetSize: CGSize {
        print("view", view.frame)
        view.layoutIfNeeded()

        let targetSize = CGSize(width: containerBounds.width - 2 * sideMargins,
                                height: UIView.layoutFittingCompressedSize.height)
        let intrinsicHeight = view.systemLayoutSizeFitting(targetSize).height

        return CGSize(width: targetSize.width, height: intrinsicHeight)
    }
    
    var containerBounds: CGRect {
        guard let container = presentationController?.containerView
            else { return view.bounds }
        
        return container.bounds
    }
}
