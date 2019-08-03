import UIKit

public class MessageBodyCell: UITableViewCell {

    public let textView: TextView = {
        let textView = TextView()
        textView.font = .secondary16ptNormal
        textView.textContainer.lineFragmentPadding = 0
        textView.isScrollEnabled = false

        return textView
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
        contentView.addSubviews(textView)
        
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: contentView.topAnchor),
            textView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            textView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            textView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            textView.heightAnchor.constraint(greaterThanOrEqualToConstant: 200)
        ])
    }

}

extension MessageBodyCell: Themeable {
    func updateColors(for theme: Theme) {
        contentView.backgroundColor = .background(for: theme)
        textView.backgroundColor = .clear
        textView.tintColor = .accent(for: theme)
        textView.textColor = .primaryText(for: theme)
        textView.attributedPlaceholder = NSAttributedString(string: "Body", attributes: [.foregroundColor: UIColor.accent(for: theme)])
    }
}
