import UIKit

extension BottomSheetPresentable where Self: UIViewController {
    /// A reference of the presentation controller as a BottomSheetPresentationController so we can access properties and methods.
    var presentationController: BottomSheetPresentationController? {
        return presentationController as? BottomSheetPresentationController
    }
    
    /// Spacing from the safe area layout guides of the presenting view controller.
    var layoutInsets: UIEdgeInsets {
        return UIApplication.shared.keyWindow?.rootViewController?.view.safeAreaInsets ?? .zero
    }
    
    /// The target y position of the bottom sheet.
    var yPos: CGFloat {
        return max(topMargin(from: height), topMargin(from: .maxHeight)) + topOffset
    }
    
    /// Computes the bottom y position to adjust for offsets.
    var bottomYPos: CGFloat {
        guard let container = presentationController?.containerView
            else { return view.bounds.height }
        
        return container.bounds.height - topOffset
    }
    
    /**
     Converts a bottom sheet height into a y position value calculated from the top of the view.
     
     - parameter height: the height of the bottom sheet.
     */
    func topMargin(from height: BottomSheetHeight) -> CGFloat {
        switch height {
        case .maxHeight:
            return 0.0
        case .maxHeightWithTopInset(let inset):
            return inset
        case .contentHeight(let height):
            return bottomYPos - (height + layoutInsets.bottom)
        case .contentHeightIgnoringSafeArea(let height):
            return bottomYPos - height
        case .intrinsicHeight:
            view.layoutIfNeeded()
            let targetSize = CGSize(width: min((presentationController?.containerView?.bounds ?? UIScreen.main.bounds).width, 500),
                                    height: UIView.layoutFittingCompressedSize.height)

            let intrinsicHeight = view.systemLayoutSizeFitting(targetSize).height
            
            return bottomYPos - intrinsicHeight
        }
    }
}
