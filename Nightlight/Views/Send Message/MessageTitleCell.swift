import UIKit

public class MessageTitleCell: UITableViewCell {

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

extension MessageTitleCell: Themeable {
    func updateColors(for theme: Theme) {
        contentView.backgroundColor = .background(for: theme)
        textField.tintColor = .accent(for: theme)
        textField.attributedPlaceholder = NSAttributedString(string: "Title", attributes: [.foregroundColor: UIColor.accent(for: theme)])
        textField.textColor = .primaryText(for: theme)
    }
}
