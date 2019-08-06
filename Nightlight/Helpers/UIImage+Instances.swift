import UIKit

extension UIImage {
    struct icon {
        static var cancel: UIImage? { return UIImage(named: "icon_cancel") }
        static var person: UIImage? { return UIImage(named: "icon_person") }
        static var lock: UIImage? { return UIImage(named: "icon_lock") }
        static var mail: UIImage? { return UIImage(named: "icon_mail") }
    }
    
    static var fullLogo: UIImage? {
        return UIImage(named: "logo_full")
    }
}
