import UIKit

/// A button that has no background color, just text.
public class TextButton: BaseButton {}

// MARK: - Themeable

extension TextButton: Themeable {
    public func updateColors(for theme: Theme) {
        setTitleColor(.label(for: theme), for: .normal)
        setTitleColor(UIColor.label(for: theme).darker(), for: .highlighted)
    }
}
