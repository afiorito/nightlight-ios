import UIKit

extension UISearchBar: Themeable {
    var textField: UITextField? {
        return subview(ofType: UITextField.self)
    }
    
    func updateColors(for theme: Theme) {
        textField?.backgroundColor = .gray(for: theme)
        textField?.tintColor = .neutral
        textField?.attributedPlaceholder = NSAttributedString(string: textField?.placeholder ?? "", attributes: [.foregroundColor: UIColor.neutral])
        textField?.leftView?.tintColor = .neutral
        textField?.textColor = .primaryText(for: theme)
    }
}
