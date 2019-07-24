import UIKit

public class BaseStaticTableViewCell: UITableViewCell, Themeable {
    func updateColors(for theme: Theme) {
        let background = UIView()
        selectedBackgroundView = background

        switch theme {
        case .light:
            background.backgroundColor = UIColor.background(for: theme).darker(amount: 0.05)
        case .dark:
            background.backgroundColor = UIColor.background(for: theme).lighter(amount: 0.05)
        }
    }
}
