import UIKit

extension SendAppreciationViewController: BottomSheetPresentable {
    public var panScrollable: UIScrollView? {
        return nil
    }
    
    public var height: BottomSheetHeight {
        return .intrinsicHeight
    }
}
