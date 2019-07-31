import UIKit

public extension ModalPresentable where Self: UIViewController {
    
    typealias AnimationBlockType = () -> Void
    typealias AnimationCompletionType = (Bool) -> Void
    typealias Presentable = UIViewController & ModalPresentable

}
