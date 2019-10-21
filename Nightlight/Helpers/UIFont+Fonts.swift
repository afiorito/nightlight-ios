import UIKit

extension UIFont {
    /// Large header, primary font with size 42pt and bold weight.
    public class var primary42ptBold: UIFont? {
        return UIFont(name: CircularStdFont.bold.rawValue, size: 42.0)
    }
    
    /// Primary font with size 22pt and bold weight.
    public class var primary24ptBold: UIFont? {
        return UIFont(name: CircularStdFont.bold.rawValue, size: 24.0)
    }
    
    /// Primary font with size 20pt and medium weight.
    public class var primary20ptMedium: UIFont? {
        return UIFont(name: CircularStdFont.medium.rawValue, size: 20.0)
    }
    
    /// Primary font with size 16pt and bold weight.
    public class var primary16ptBold: UIFont? {
        return UIFont(name: CircularStdFont.bold.rawValue, size: 16.0)
    }
    
    /// Primary font with size 16pt and medium weight.
    public class var primary16ptMedium: UIFont? {
        return UIFont(name: CircularStdFont.medium.rawValue, size: 16.0)
    }
    
    /// Primary font with size 16pt and bold weight.
    public class var primary17ptNormal: UIFont? {
        return UIFont(name: CircularStdFont.book.rawValue, size: 17.0)
    }
    
    /// Primary font with size 16pt and medium weight.
    public class var primary17ptMedium: UIFont? {
        return UIFont(name: CircularStdFont.medium.rawValue, size: 17.0)
    }
    
    /// Primary font with size 16pt and normal weight.
    public class var primary16ptNormal: UIFont? {
        return UIFont(name: CircularStdFont.book.rawValue, size: 16.0)
    }
    
    /// Primary font with size 12pt and normal weight.
    public class var primary12ptNormal: UIFont? {
        return UIFont(name: CircularStdFont.book.rawValue, size: 12.0)
    }
    
    /// Primary font with size 12pt and bold weight.
    public class var primary12ptBold: UIFont? {
        return UIFont(name: CircularStdFont.bold.rawValue, size: 12.0)
    }
    
    /// Secondary font with size 16pt and medium weight.
    public class var secondary16ptMedium: UIFont? {
        return UIFont.systemFont(ofSize: 16.0, weight: .medium)
    }
    
    /// Secondary font with size 16pt and medium weight.
    public class var secondary16ptBold: UIFont? {
        return UIFont.systemFont(ofSize: 16.0, weight: .bold)
    }
    
    /// Secondary font with size 16pt and normal weight.
    public class var secondary16ptNormal: UIFont? {
        return UIFont.systemFont(ofSize: 16.0)
    }
    
    /// Secondary font with size 14pt and normal weight.
    public class var secondary14ptNormal: UIFont? {
        return UIFont.systemFont(ofSize: 14.0)
    }
    
}
