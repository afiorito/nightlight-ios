import UIKit

public extension BottomSheetPresentable where Self: UIViewController {
    
    typealias AnimationBlockType = () -> Void
    typealias AnimationCompletionType = (Bool) -> Void
    typealias Presentable = UIViewController & BottomSheetPresentable

}
