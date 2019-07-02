import UIKit

// MARK: - Theme Colors

extension UIColor {
    /// Nightlight brand color.
    public class var brand: UIColor {
        return Palette.blue
    }
    
    /**
     Handles the color for the background of standard content.
     
     - parameter theme: the theme to determine the the background color.
     */
    public class func background(for theme: Theme) -> UIColor {
        switch theme {
        case .light:
            return Palette.white
        case .dark:
            return Palette.black
            
        }
    }
    
    /**
     Handles the the color for black and white elements.
     
     - parameter theme: the theme to determine the grayscale color.
     */
    public class func primaryGrayScale(for theme: Theme) -> UIColor {
        switch theme {
        case .light:
            return Palette.black
        case .dark:
            return Palette.white
        }
    }
    
    /**
     Handles the color for subtle accent colors.
     
     - parameter theme: the theme to determine the accent color.
     */
    public class func accent(for theme: Theme) -> UIColor {
        switch theme {
        case .light:
            return Palette.lightAccent
        case .dark:
            return Palette.darkAccent
        }
    }
    
    /**
     Handles the primary text color for content.
     
     - parameter theme: the theme to determine the primary text color.
     */
    public class func primaryTextColor(for theme: Theme) -> UIColor {
        switch theme {
        case .light:
            return Palette.black
        case .dark:
            return Palette.white
        }
    }
    
    /// Secondary text color for all backgrounds.
    public class var secondaryTextColor: UIColor {
        return Palette.darkAccent
    }
}

// MARK: - Color Names

extension UIColor {
    struct Palette {
        static let white = UIColor.white
        static let alternateWhite = UIColor(hex: "FAFBFC")
        static let black = UIColor(hex: "31363A")
        static let alternateBlack = UIColor(hex: "3B4248")
        static let blue = UIColor(hex: "79B6F2")
        static let urgent = UIColor(hex: "F77071")
        static let darkGrey = UIColor(hex: "363B3F")
        static let lightGrey = UIColor(hex: "F7F7F7")
        static let lightAccent = UIColor(hex: "C3C3C6")
        static let darkAccent = UIColor(hex: "8A939A")
        static let lightShadow = UIColor(hex: "E4EAF0")
        static let darkShadow = UIColor(hex: "2D3236")
        static let active = UIColor(hex: "4BC361")
        static let darkBorder = UIColor(hex: "3D4347")
        static let lightBorder = UIColor(hex: "F2F2F2")
    }
}
