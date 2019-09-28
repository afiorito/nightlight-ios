import UIKit

/// The table view cell for entering the title of a message.
public class MessageTitleCell: UITableViewCell {

    /// A text field for inputting the message title.
    public let textField: UITextField = {
        let textField = UITextField()
        textField.font = .secondary16ptNormal
        return textField
    }()
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        prepareSubviews()
        updateColors(for: theme)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func prepareSubviews() {
        contentView.addSubviews(textField)
        
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            textField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            textField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            textField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15)
        ])
    }

}

// MARK: - Themeable

extension MessageTitleCell: Themeable {
    func updateColors(for theme: Theme) {
        backgroundColor = .background(for: theme)
        textField.tintColor = .label(for: theme)
        textField.attributedPlaceholder = NSAttributedString(string: "Title", attributes: [.foregroundColor: UIColor.placeholder(for: theme)])
        textField.textColor = .label(for: theme)
    }
}
