import UIKit

/// A static table view cell encompassing basic styling.
public class BaseStaticTableViewCell: UITableViewCell, Themeable {
    func updateColors(for theme: Theme) {
        selectedBackgroundView = {
            let view = UIView()
            view.backgroundColor = UIColor.gray3(for: theme).withAlphaComponent(0.3)
            return view
        }()
        
        (accessoryView as? UIActivityIndicatorView)?.color = .gray(for: theme)
    }
}
