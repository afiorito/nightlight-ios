import UIKit

// MARK: - Theme Colors

extension UIColor {
    /// Nightlight brand color.
    public class var brand: UIColor {
        return Palette.blue
    }
    
    /**
     Handles the color for the background of standard content.
     
     - parameter theme: the theme to determine the background color.
     
     - returns: the palette color for the background of standard content.
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
     Handles the color for the alternate background color of elements.
     
     - parameter theme: the theme to determine the alternate background color.
     
     - returns: the palette color for the alternate background color of elements.
     */
    public class func alternateBackground(for theme: Theme) -> UIColor {
        switch theme {
        case .light:
            return Palette.alternateWhite
        case .dark:
            return Palette.alternateBlack
            
        }
    }
    
    /**
     Handles the color for the background of elements to be visible on
     the background color of standard content.
     
     - parameter theme: the theme to determine the element background color.
     
     - returns: the palette color for an element background.
     */
    public class func elementBackground(for theme: Theme) -> UIColor {
        switch theme {
        case .light:
            return Palette.lightGrey
        case .dark:
            return Palette.darkGrey
            
        }
    }
    
    /**
     Handles the color for the background of cells that stick out from the background.
     
     - parameter theme: the theme to determine the cell background color.
     
     - returns: the palette color for the cell background.
     */
    public class func cellBackground(for theme: Theme) -> UIColor {
        switch theme {
        case .light:
            return Palette.white
        case .dark:
            return Palette.darkGrey
            
        }
    }
    
    /**
     Handles the color for black and white elements.
     
     - parameter theme: the theme to determine the grayscale color.
     
     - returns: the palette color for black and white elements.
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
     
     - returns: the palette color for subtle accents.
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
     Handles the color for drop shadows.
     
     - parameter theme: the theme to determine the shadow color.
     
     - returns: the palette color for drop shadows.
     */
    public class func shadow(for theme: Theme) -> UIColor {
        switch theme {
        case .light:
            return Palette.lightShadow
        case .dark:
            return Palette.darkShadow
        }
    }
    
    /**
     Handles the color for borders.
     
     - parameter theme: the theme to determine the border color.
     
     - returns: the palette color for borders.
     */
    public class func border(for theme: Theme) -> UIColor {
        switch theme {
        case .light:
            return Palette.lightBorder
        case .dark:
            return Palette.darkBorder
        }
    }
    
    /**
     Handles the primary text color.
     
     - parameter theme: the theme to determine the primary text color.
     
     - returns: the palette color for primary text.
     */
    public class func primaryText(for theme: Theme) -> UIColor {
        switch theme {
        case .light:
            return Palette.black
        case .dark:
            return Palette.white
        }
    }
    
    /**
     Handles the inverted primary text color for content.
     
     - parameter theme: the theme to determine the inverted primary text color.
     
     - returns the palette color for inverted primary text.
     */
    public class func invertedPrimaryText(for theme: Theme) -> UIColor {
        switch theme {
        case .light:
            return Palette.white
        case .dark:
            return Palette.black
        }
    }
    
    /**
     Handles the color for the inverted background of standard content.
     
     - parameter theme: the theme to determine the inverted background color.
     
     - returns: the palette color for the inverted background of standard content.
     */
    public class func invertedBackground(for theme: Theme) -> UIColor {
        switch theme {
        case .light:
            return Palette.black
        case .dark:
            return Palette.white
            
        }
    }
    
    /**
     Handles the color for buttons with neutral backgrounds.
     
     - parameter theme: the theme to determine the neutral button background color.
     
     - returns: the palette color for a neutral button background color.
     */
    public class func buttonNeutral(for theme: Theme) -> UIColor {
        switch theme {
        case .light:
            return Palette.alternateLightGrey
        case .dark:
            return Palette.alternateBlack
        }
    }
    
    /**
     Handles the color for gray content.
     
     - parameter theme: the theme to determine the gray color.
     
     - returns: the palette color for gray content.
     */
    public class func gray(for theme: Theme) -> UIColor {
        switch theme {
        case .light:
            return Palette.lightGrey
        case .dark:
            return Palette.darkGrey
        }
    }
    
    /// Secondary text color for all backgrounds.
    public class var secondaryText: UIColor {
        return Palette.darkAccent
    }
    
    /// Represents color for hinting an urgent or erroneous occurence.
    public class var urgent: UIColor {
        return Palette.urgent
    }
    
    /// Represents color for hinting a successful event.
    public class var success: UIColor {
        return Palette.active
    }
    
    /// Represents color for hinting a neutral occurence.
    public class var neutral: UIColor {
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
        static let alternateLightGrey = UIColor(hex: "E5EBF0")
        static let lightAccent = UIColor(hex: "C3C3C6")
        static let darkAccent = UIColor(hex: "8A939A")
        static let lightShadow = UIColor(hex: "E4EAF0")
        static let darkShadow = UIColor(hex: "2D3236")
        static let active = UIColor(hex: "4BC361")
        static let darkBorder = UIColor(hex: "3D4347")
        static let lightBorder = UIColor(hex: "F2F2F2")
    }
}
