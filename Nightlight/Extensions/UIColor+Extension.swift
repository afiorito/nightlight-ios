import UIKit

extension UIColor {
    /**
     Creates a color object using the specified opacity and RGB component values.
     
     - parameter red: the red value of the color (0-255).
     - parameter green: the green value of the color (0-255).
     - parameter blue: the blue value of the color (0-255).
     - parameter alpha: the alpha component of the color (0-100).
     */
    public convenience init(red: Int, green: Int, blue: Int, alpha: Int) {
        self.init(red: CGFloat(red) / 255.0,
                  green: CGFloat(green) / 255.0,
                  blue: CGFloat(blue) / 255.0,
                  alpha: CGFloat(alpha) / 100.0)
    }
    
    /**
     Creates a color from an hex string (e.g. "#3498db").
     
     If the given hex string is invalid the initialiser will create a black color.
     
     - parameter hex: A hexa-decimal color string representation.
     */
    public convenience init(hex: String) {
        let hexString = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        let scanner = Scanner(string: hexString)
        
        if hexString.hasPrefix("#") {
            scanner.scanLocation = 1
        }
        
        if hexString.count == 6 {
            var color: UInt32 = 0
            Scanner(string: hexString).scanHexInt32(&color)
            
            self.init(red: Int((color & 0xFF0000) >> 16),
                      green: Int((color & 0x00FF00) >> 8),
                      blue: Int(color & 0x0000FF),
                      alpha: 100)
        } else {
            self.init(red: 0, green: 0, blue: 0, alpha: 100)
        }
        
    }
    
    /**
     Returns a color with the lightness increased by the given amount.
     
     If the given color could not be converted to hsb, returns the original color.
     
     - parameter amount: CGFloat between 0.0 and 1.0.
     
     - returns: A lighter UIColor.
     */
    public func lighter(amount: CGFloat = 0.2) -> UIColor {
        var h: CGFloat = 0.0
        var s: CGFloat = 0.0
        var b: CGFloat = 0.0
        var a: CGFloat = 0.0
        
        if self.getHue(&h, saturation: &s, brightness: &b, alpha: &a) {
            return UIColor(hue: h, saturation: s, brightness: b * (1 + amount), alpha: a)
        }
        
        return self
    }
    
    /**
     Returns a color with the darkness increased by the given amount.
     
     If the given color could not be converted to hsb, returns the original color.
     
     - parameter amount: CGFloat between 0.0 and 1.0.
     
     - returns: A darker UIColor.
     */
    public func darker(amount: CGFloat = 0.2) -> UIColor {
        var h: CGFloat = 0.0
        var s: CGFloat = 0.0
        var b: CGFloat = 0.0
        var a: CGFloat = 0.0
        
        if self.getHue(&h, saturation: &s, brightness: &b, alpha: &a) {
            return UIColor(hue: h, saturation: s, brightness: b * (1 - amount), alpha: a)
        }
        
        return self
    }
    
    public func asImage(with size: CGSize = CGSize(width: 1, height: 1)) -> UIImage? {
        UIGraphicsBeginImageContext(size)
        let ctx = UIGraphicsGetCurrentContext()
        self.setFill()
        ctx?.fill(CGRect(origin: .zero, size: size))
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
    
    public var hexString: String {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0

        getRed(&r, green: &g, blue: &b, alpha: &a)

        let rgb: Int = (Int)(r * 255) << 16 | (Int)(g * 255) << 8 | (Int)(b * 255)

        return String(format: "#%06x", rgb)
    }

}
