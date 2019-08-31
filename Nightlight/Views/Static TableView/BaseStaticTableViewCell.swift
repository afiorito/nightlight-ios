import UIKit

/// A static table view cell encompassing basic styling.
public class BaseStaticTableViewCell: UITableViewCell, Themeable {
    func updateColors(for theme: Theme) {
        if theme == .system {
            selectedBackgroundView = nil
        } else {
            let background = UIView()
            selectedBackgroundView = background

            switch theme {
            case .dark:
                background.backgroundColor = UIColor.background(for: theme).lighter(amount: 0.05)
            default:
                background.backgroundColor = UIColor.background(for: theme).darker(amount: 0.05)
            }
        }
    }
}
