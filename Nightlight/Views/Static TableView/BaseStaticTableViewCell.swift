import UIKit

/// A static table view cell encompassing basic styling.
public class BaseStaticTableViewCell: UITableViewCell, Themeable {
    public override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        
        UIView.animate(withDuration: 0.25) {
            if highlighted {
                switch self.theme {
                case .dark:
                    self.backgroundColor = UIColor.background(for: self.theme).lighter(amount: 0.05)
                case .light:
                    self.backgroundColor = UIColor.background(for: self.theme).darker(amount: 0.05)
                case .system: break
                }
            } else {
                self.backgroundColor = UIColor.background(for: self.theme)
            }
        }
    }

    func updateColors(for theme: Theme) {
        if theme == .system {
            selectionStyle = .default
        } else {
            selectionStyle = .none
        }
        
        (accessoryView as? UIActivityIndicatorView)?.color = .gray(for: theme)
    }
}
