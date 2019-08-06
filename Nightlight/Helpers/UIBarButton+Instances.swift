import UIKit

extension UIBarButtonItem {
    static func cancel(target: Any?, action: Selector) -> UIBarButtonItem {
        return UIBarButtonItem(image: UIImage.icon.cancel, style: .plain, target: target, action: action)
    }
}
