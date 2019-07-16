import UIKit

extension ContextMenuViewController: BottomSheetPresentable {
    public var panScrollable: UIScrollView? {
        return nil
    }
    
    public var height: BottomSheetHeight {
        return .intrinsicHeight
    }
    
    public var topOffset: CGFloat {
        return 200
    }
}
