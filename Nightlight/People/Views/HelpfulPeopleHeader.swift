import UIKit

/// A header view for the helpful people table view.
public class HelpfulPeopleHeader: UITableViewHeaderFooterView {
    
    /// A label for displaying the title of the header.
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Helpful People"
        label.font = .primary16ptBold
        
        return label
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        prepareSubviews()
        updateColors(for: theme)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func prepareSubviews() {
        contentView.addSubviews(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            titleLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -10)
        ])
    }
}

// MARK: - Themeable

extension HelpfulPeopleHeader: Themeable {
    func updateColors(for theme: Theme) {
        let backgroundView = UIView()
        backgroundView.backgroundColor = .darkBackground(for: theme)
        self.backgroundView = backgroundView
        titleLabel.textColor = .primaryText(for: theme)
    }
}
