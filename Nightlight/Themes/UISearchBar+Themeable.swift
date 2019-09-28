import UIKit

extension UISearchBar: Themeable {
    var textField: UITextField? {
        return subview(ofType: UITextField.self)
    }
    
    func updateColors(for theme: Theme) {
        textField?.attributedPlaceholder = NSAttributedString(string: textField?.placeholder ?? "", attributes: [.foregroundColor: UIColor.placeholder(for: theme)])
        textField?.textColor = .label(for: theme)
        textField?.backgroundColor = .secondaryBackground(for: theme)
        textField?.leftView?.tintColor = .placeholder(for: theme)
        textField?.tintColor = .label(for: theme)
    }
}
