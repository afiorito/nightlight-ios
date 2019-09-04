import UIKit

/// A static table view cell encompassing basic styling.
public class BaseStaticTableViewCell: UITableViewCell, Themeable {
    public override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        
        if highlighted {
            switch theme {
            case .dark:
               backgroundColor = UIColor.background(for: theme).lighter(amount: 0.05)
            case .light:
                backgroundColor = UIColor.background(for: theme).darker(amount: 0.05)
            case .system: break
            }
        } else {
            backgroundColor = UIColor.background(for: theme)
        }
    }

    func updateColors(for theme: Theme) {
        if theme == .system {
            selectionStyle = .default
        } else {
            selectionStyle = .none
        }
    }
}
