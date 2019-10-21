import UIKit

// MARK: - Theme Colors

extension UIColor {
    /// Nightlight brand color.
    public class var brand: UIColor {
        return Palette.light.blue
    }
    
    /**
     Returns the color for the main background of an interface.
     
     - parameter theme: The theme to determine the background color.
     */
    public class func background(for theme: Theme) -> UIColor {
        if theme == .system, #available(iOS 13.0, *) {
            return .systemBackground
        }

        return select((light: Palette.light.background, dark: Palette.dark.background), for: theme)
    }
    
    /**
     Returns the color for content layered on top of the main background.
     
     - parameter theme: The theme to determine the background color.
     */
    public class func secondaryBackground(for theme: Theme) -> UIColor {
        if theme == .system, #available(iOS 13.0, *) {
            return .secondarySystemBackground
        }
        
        return select((light: Palette.light.secondaryBackground, dark: Palette.dark.secondaryBackground), for: theme)
    }
    
    /**
     Returns the color for content layered on top of a secondary background.
     
     - parameter theme: The theme to determine the background color.
     */
    public class func tertiaryBackground(for theme: Theme) -> UIColor {
        if theme == .system, #available(iOS 13.0, *) {
            return .tertiarySystemBackground
        }
        
        return select((light: Palette.light.tertiaryBackground, dark: Palette.dark.tertiaryBackground), for: theme)
    }
    
    /**
     Returns the color for the main background of a grouped interface.
     
     - parameter theme: The theme to determine the grouped background color.
     */
    public class func groupedBackground(for theme: Theme) -> UIColor {
        if theme == .system, #available(iOS 13.0, *) {
            return .systemGroupedBackground
        }
        
        return select((light: Palette.light.groupedBackground, dark: Palette.dark.groupedBackground), for: theme)
    }
    
    /**
     Returns the color for content layered on top of a grouped background.
     
     - parameter theme: The theme to determine the grouped background color.
     */
    public class func secondaryGroupedBackground(for theme: Theme) -> UIColor {
        if theme == .system, #available(iOS 13.0, *) {
            return .secondarySystemGroupedBackground
        }
        
        return select((light: Palette.light.secondaryGroupedBackground, dark: Palette.dark.secondaryGroupedBackground), for: theme)
    }
    
    /**
     Returns the base gray color.
     
     - parameter theme: The theme to determine the gray color.
     */
    public class func gray(for theme: Theme) -> UIColor {
        if theme == .system, #available(iOS 13.0, *) {
            return .systemGray
        }
        
        return select((light: Palette.light.gray1, dark: Palette.dark.gray1), for: theme)
    }
    
    /**
     Returns the second-level shade of gray.
     
     - parameter theme: The theme to determine the gray color.
     */
    public class func gray2(for theme: Theme) -> UIColor {
        if theme == .system, #available(iOS 13.0, *) {
            return .systemGray2
        }
        
        return select((light: Palette.light.gray2, dark: Palette.dark.gray2), for: theme)
    }
    
    /**
     Returns the third-level shade of gray.
     
     - parameter theme: The theme to determine the gray color.
     */
    public class func gray3(for theme: Theme) -> UIColor {
        if theme == .system, #available(iOS 13.0, *) {
            return .systemGray3
        }
        
        return select((light: Palette.light.gray3, dark: Palette.dark.gray3), for: theme)
    }
    
    /**
     Returns the fourth-level shade of gray.
     
     - parameter theme: The theme to determine the gray color.
     */
    public class func gray4(for theme: Theme) -> UIColor {
        if theme == .system, #available(iOS 13.0, *) {
            return .systemGray4
        }
        
        return select((light: Palette.light.gray4, dark: Palette.dark.gray4), for: theme)
    }
    
    /**
     Returns the fifth-level shade of gray.
     
     - parameter theme: The theme to determine the gray color.
     */
    public class func gray5(for theme: Theme) -> UIColor {
        if theme == .system, #available(iOS 13.0, *) {
            return .systemGray5
        }
        
        return select((light: Palette.light.gray5, dark: Palette.dark.gray5), for: theme)
    }
    
    /**
     Returns the sixth-level shade of gray.
     
     - parameter theme: The theme to determine the gray color.
     */
    public class func gray6(for theme: Theme) -> UIColor {
        if theme == .system, #available(iOS 13.0, *) {
            return .systemGray6
        }
        
        return select((light: Palette.light.gray6, dark: Palette.dark.gray6), for: theme)
    }
    
    /**
     Handles the color for drop shadows.
     
     - parameter theme: the theme to determine the shadow color.
     
     - returns: the palette color for drop shadows.
     */
    public class func shadow(for theme: Theme) -> UIColor {
        if theme == .system, #available(iOS 13.0, *) {
            return .systemGray5
        }
        
        return select((light: Palette.light.shadow, dark: Palette.dark.shadow), for: theme)
    }
    
    /**
     Handles the color for borders.
     
     - parameter theme: the theme to determine the border color.
     
     - returns: the palette color for borders.
     */
    public class func separator(for theme: Theme) -> UIColor {
        if theme == .system, #available(iOS 13.0, *) {
            return .separator
        }
        
        return select((light: Palette.light.separator, dark: Palette.dark.separator), for: theme)
    }
    
    /**
     Returns the color for text labels that contain primary content.
     
     - parameter theme: The theme to determine the text color.
     */
    public class func label(for theme: Theme) -> UIColor {
        if theme == .system, #available(iOS 13.0, *) {
            return .label
        }
        
        return select((light: Palette.light.label, dark: Palette.dark.label), for: theme)
    }
    
    /**
     Returns the color for text labels that contain secondary content..
     
     - parameter theme: the theme to determine the text color.
     */
    public class func secondaryLabel(for theme: Theme) -> UIColor {
        if theme == .system, #available(iOS 13.0, *) {
            return .secondaryLabel
        }

        return select((light: Palette.light.secondaryLabel, dark: Palette.dark.secondaryLabel), for: theme)
    }
    
    /**
     Returns the color for text labels that contain tertiary content..
     
     - parameter theme: the theme to determine the text color.
     */
    public class func tertiaryLabel(for theme: Theme) -> UIColor {
        if theme == .system, #available(iOS 13.0, *) {
            return .tertiaryLabel
        }

        return select((light: Palette.light.tertiaryLabel, dark: Palette.dark.tertiaryLabel), for: theme)
    }

    /**
     Returns the color for placeholder text in controls or text views.
     
     - parameter theme: The theme to determine the placeholder color.
     */
    public class func placeholder(for theme: Theme) -> UIColor {
        if theme == .system, #available(iOS 13.0, *) {
            return .placeholderText
        }
        
        return select((light: Palette.light.tertiaryLabel, dark: Palette.dark.tertiaryLabel), for: theme)
    }
    
    /**
     Handles the inverted primary text color for content.
     
     - parameter theme: the theme to determine the inverted primary text color.
     
     - returns the palette color for inverted primary text.
     */
    public class func invertedPrimaryText(for theme: Theme) -> UIColor {
        if let color = UIColor(named: "invertedLabel"),
            theme == .system,
            #available(iOS 13.0, *) {
            return color
        }
        
        return select((light: Palette.dark.label, dark: Palette.light.label), for: theme)
    }

    /// Represents color for hinting an urgent or erroneous occurence.
    public class var urgent: UIColor {
        return Palette.light.red
    }
    
    /// Represents color for hinting a successful event.
    public class var success: UIColor {
        return Palette.light.green
    }
    
    private class func select(_ colors: (light: UIColor, dark: UIColor), for theme: Theme) -> UIColor {
        switch theme {
        case .dark:
            return colors.dark
        default:
            return colors.light
        }
    }

}

// MARK: - Color Names

extension UIColor {
    struct Palette {
        struct light {
            static let blue = UIColor(red: 121, green: 182, blue: 242, alpha: 100)
            static let red = UIColor(red: 242, green: 97, blue: 98, alpha: 100)
            static let green = UIColor(red: 75, green: 195, blue: 97, alpha: 100)
            
            static let label = UIColor(red: 43, green: 46, blue: 51, alpha: 100)
            static let secondaryLabel = UIColor(red: 61, green: 67, blue: 77, alpha: 60)
            static let tertiaryLabel = UIColor(red: 61, green: 67, blue: 77, alpha: 30)
            static let quarternaryLabel = UIColor(red: 61, green: 67, blue: 77, alpha: 18)
            
            static let background = UIColor(red: 255, green: 255, blue: 255, alpha: 100)
            static let secondaryBackground = UIColor(red: 242, green: 245, blue: 247, alpha: 100)
            static let tertiaryBackground = UIColor(red: 255, green: 255, blue: 255, alpha: 100)
            
            static let groupedBackground = UIColor(red: 242, green: 245, blue: 247, alpha: 100)
            static let secondaryGroupedBackground = UIColor(red: 255, green: 255, blue: 255, alpha: 100)
            static let tertiaryGroupedBackground = UIColor(red: 242, green: 245, blue: 247, alpha: 100)
            
            static let gray1 = UIColor(red: 139, green: 144, blue: 148, alpha: 100)
            static let gray2 = UIColor(red: 175, green: 177, blue: 179, alpha: 100)
            static let gray3 = UIColor(red: 199, green: 202, blue: 204, alpha: 100)
            static let gray4 = UIColor(red: 209, green: 212, blue: 214, alpha: 100)
            static let gray5 = UIColor(red: 229, green: 232, blue: 235, alpha: 100)
            static let gray6 = UIColor(red: 242, green: 245, blue: 247, alpha: 100)
            
            static let separator = UIColor(red: 61, green: 67, blue: 77, alpha: 29)
            static let opaqueSeparator = UIColor(red: 199, green: 200, blue: 203, alpha: 100)
            
            static let shadow = UIColor(hex: "DAE0E6")
        }
        
        struct dark {
            static let label = UIColor(red: 255, green: 255, blue: 255, alpha: 100)
            static let secondaryLabel = UIColor(red: 206, green: 219, blue: 230, alpha: 60)
            static let tertiaryLabel = UIColor(red: 206, green: 219, blue: 230, alpha: 30)
            static let quarternaryLabel = UIColor(red: 206, green: 219, blue: 230, alpha: 18)
            
            static let background = UIColor(red: 43, green: 46, blue: 51, alpha: 100)
            static let secondaryBackground = UIColor(red: 58, green: 63, blue: 66, alpha: 100)
            static let tertiaryBackground = UIColor(red: 69, green: 76, blue: 82, alpha: 100)
            static let quarternaryBackground = UIColor(red: 86, green: 95, blue: 102, alpha: 100)
            
            static let groupedBackground = UIColor(red: 40, green: 43, blue: 46, alpha: 100)
            static let secondaryGroupedBackground = UIColor(red: 58, green: 63, blue: 66, alpha: 100)
            static let tertiaryGroupedBackground = UIColor(red: 69, green: 76, blue: 82, alpha: 100)
            static let quarternaryGroupedBackground = UIColor(red: 86, green: 95, blue: 102, alpha: 100)
            
            static let gray1 = UIColor(red: 139, green: 144, blue: 148, alpha: 100)
            static let gray2 = UIColor(red: 96, green: 99, blue: 102, alpha: 100)
            static let gray3 = UIColor(red: 69, green: 72, blue: 74, alpha: 100)
            static let gray4 = UIColor(red: 57, green: 60, blue: 61, alpha: 100)
            static let gray5 = UIColor(red: 43, green: 45, blue: 46, alpha: 100)
            static let gray6 = UIColor(red: 29, green: 30, blue: 31, alpha: 100)
            
            static let separator = UIColor(red: 60, green: 62, blue: 64, alpha: 65)
            static let opaqueSeparator = UIColor(red: 52, green: 55, blue: 57, alpha: 100)
            
            static let shadow = UIColor(hex: "272B2E")
        }
        
    }
}
