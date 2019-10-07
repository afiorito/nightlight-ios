import UIKit

/// The table view cell for entering the body of a message.
public class MessageBodyCell: UITableViewCell {
    /// Random adjectives for the placeholder text.
    private let adjectives = [
        "kind",
        "motivational",
        "helpful",
        "wonderful",
        "inspiring",
        "powerful",
        "important",
        "insightful",
        "impactful",
        "beautiful",
        "great"
    ]
    
    /// The adjective displayed by the placeholder text.
    private var adjective: String {
        return adjectives[Int.random(in: 0..<adjectives.count)]
    }
    
    /// A text view for inputting the message body.
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
            textView.heightAnchor.constraint(greaterThanOrEqualToConstant: min(UIScreen.main.bounds.height / 3, 400))
        ])
    }

}

// MARK: - Themeable

extension MessageBodyCell: Themeable {
    func updateColors(for theme: Theme) {
        backgroundColor = .background(for: theme)
        textView.backgroundColor = .clear
        textView.tintColor = .label(for: theme)
        textView.textColor = .label(for: theme)
        textView.attributedPlaceholder = NSAttributedString(string: "Say something \(adjective)...", attributes: [.foregroundColor: UIColor.placeholder(for: theme)])
    }
}
