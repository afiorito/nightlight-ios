import UIKit

/// The table view cell for selecting the number of people.
public class NumPeopleCell: UITableViewCell {
    
    /// A pattern for limiting the number of people input.
    private let regex: NSRegularExpression = try! NSRegularExpression(pattern: "^(^$|[1-5])$")
    
    /// A text field for inputting the number of people.
    public let textField: UITextField = {
        let textField = UITextField()
        textField.text = "10"
        textField.sizeToFit()
        textField.keyboardType = .numberPad
        textField.font = .primary17ptMedium
        textField.textAlignment = .center
        return textField
    }()
    
    override public init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        self.textLabel?.text = Strings.message.numPeople
        textLabel?.font = .primary17ptNormal
        self.accessoryView = textField
        textField.delegate = self
        textField.frame.size.height = contentView.frame.height
        detailTextLabel?.text = "Number of random message recipients."
        
        updateColors(for: theme)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        textField.frame.size.height = contentView.frame.height
        textField.frame.size.width = UISwitch().intrinsicContentSize.width
        textField.frame.origin.y = 0
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: UITextField Delegate

extension NumPeopleCell: UITextFieldDelegate {
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let text = textField.text ?? ""
        
        guard let stringRange = Range(range, in: text)
            else { return false }
        
        let updatedText = text.replacingCharacters(in: stringRange, with: string)
        return regex.matches(updatedText)
    }
    
}

// MARK: - Themeable

extension NumPeopleCell: Themeable {
    func updateColors(for theme: Theme) {
        textLabel?.textColor = .label(for: theme)
        backgroundColor = .background(for: theme)
        accessoryView?.backgroundColor = .background(for: theme)
        textField.textColor = .secondaryLabel(for: theme)
    }
}
