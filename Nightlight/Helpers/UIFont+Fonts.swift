import UIKit

extension UIFont {
    /// Primary font with size 20pt and medium weight.
    public class var primary20ptMedium: UIFont? {
        return UIFont(name: CircularStdFont.medium.rawValue, size: 20.0)
    }
    
    /// Primary font with size 16pt and bold weight.
    public class var primary16ptBold: UIFont? {
        return UIFont(name: CircularStdFont.bold.rawValue, size: 16.0)
    }
    
    /// Secondary font with size 16pt.
    public class var secondary16ptMedium: UIFont? {
        return UIFont.systemFont(ofSize: 16.0, weight: .medium)
    }
}
