import UIKit

class Switch: UISwitch {

}

extension Switch: Themeable {
    func updateColors(for theme: Theme) {
        self.tintColor = .alternateBackground(for: theme)
        self.onTintColor = .success
    }
}
