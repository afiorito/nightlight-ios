import UIKit

public class HelpfulPeopleHeader: UITableViewHeaderFooterView {
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
        addSubviews(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
        ])
    }
}

// MARK: - Themeable

extension HelpfulPeopleHeader: Themeable {
    func updateColors(for theme: Theme) {
        let backgroundView = UIView()
        backgroundView.backgroundColor = .background(for: theme)
        self.backgroundView = backgroundView
        titleLabel.textColor = .primaryText(for: theme)
    }
}
