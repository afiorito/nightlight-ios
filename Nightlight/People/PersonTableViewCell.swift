import UIKit

/// A table view cell for displaying a person.
public class PersonTableViewCell: UITableViewCell, Configurable, Delegating {    
    /// The delegate for managing UI actions.
    public weak var delegate: AnyObject?
    
    /// A view for simulating a card like appearance for a table view cell.
    private let backgroundCardView = UIView()
    
    /// The content of the table view cell.
    private let personContentView = PersonContentView()
    
    override public init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        backgroundCardView.layer.cornerRadius = 4
        prepareSubviews()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(with viewModel: PersonViewModel) {
        
        personContentView.usernameLabel.text = viewModel.username
        personContentView.dateLabel.text = viewModel.helpingSince
        personContentView.loveAccolade.actionView.count = viewModel.totalLove
        personContentView.appreciateAccolade.actionView.count = viewModel.totalAppreciation
        
        updateColors(for: theme)
    }
    
    private func prepareSubviews() {
        contentView.addSubviews([backgroundCardView, personContentView])
        
        NSLayoutConstraint.activate([
            personContentView.topAnchor.constraint(equalTo: backgroundCardView.topAnchor, constant: 10),
            personContentView.leadingAnchor.constraint(equalTo: backgroundCardView.leadingAnchor, constant: 15),
            personContentView.trailingAnchor.constraint(equalTo: backgroundCardView.trailingAnchor, constant: -15),
            personContentView.bottomAnchor.constraint(equalTo: backgroundCardView.bottomAnchor, constant: -15),
            backgroundCardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            backgroundCardView.leadingAnchor.constraint(equalTo: contentView.readableContentGuide.leadingAnchor),
            backgroundCardView.trailingAnchor.constraint(equalTo: contentView.readableContentGuide.trailingAnchor),
            backgroundCardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }

}

// MARK: - Themeable

extension PersonTableViewCell: Themeable {
    func updateColors(for theme: Theme) {
        backgroundColor = nil
        backgroundCardView.backgroundColor = .secondaryGroupedBackground(for: theme)
        personContentView.updateColors(for: theme)
    }
}
