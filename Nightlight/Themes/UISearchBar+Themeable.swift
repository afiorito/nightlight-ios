import UIKit

extension UISearchBar: Themeable {
    var textField: UITextField? {
        return subview(ofType: UITextField.self)
    }
    
    func updateColors(for theme: Theme) {
        if theme != .system {
            textField?.attributedPlaceholder = NSAttributedString(string: textField?.placeholder ?? "",
                                                                  attributes: [.foregroundColor: UIColor.gray(for: theme)])
        } else {
            textField?.backgroundColor = nil
            textField?.placeholder = "Search"
        }

        textField?.textColor = .primaryText(for: theme)
        textField?.backgroundColor = .gray6(for: theme)
        textField?.leftView?.tintColor = .gray(for: theme)
        textField?.tintColor = .gray(for: theme)
    }
}
