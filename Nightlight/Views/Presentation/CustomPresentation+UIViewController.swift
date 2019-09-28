import UIKit

public extension CustomPresentable where Self: UIViewController {
    typealias AnimationBlockType = () -> Void
    typealias AnimationCompletionType = (Bool) -> Void
    typealias PresentableViewController = UIViewController & CustomPresentable
}
