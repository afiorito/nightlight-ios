import UIKit

extension BottomSheetPresentable where Self: UIViewController {
    var presentationController: BottomSheetPresentationController? {
        return presentationController as? BottomSheetPresentationController
    }
    
    var layoutInsets: UIEdgeInsets {
        return UIApplication.shared.keyWindow?.rootViewController?.view.safeAreaInsets ?? .zero
    }
    
    var yPos: CGFloat {
        return max(topMargin(from: height), topMargin(from: .maxHeight)) + topOffset
    }
    
    var bottomYPos: CGFloat {
        guard let container = presentationController?.containerView
            else { return view.bounds.height }
        
        return container.bounds.height - topOffset
    }
    
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
            let targetSize = CGSize(width: (presentationController?.containerView?.bounds ?? UIScreen.main.bounds).width,
                                    height: UIView.layoutFittingCompressedSize.height)
            let intrinsicHeight = view.systemLayoutSizeFitting(targetSize).height
            
            return bottomYPos - (intrinsicHeight + layoutInsets.bottom)
        }
    }
}
