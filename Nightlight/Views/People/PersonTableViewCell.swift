import UIKit

public class PersonTableViewCell: UITableViewCell, Configurable {
    public typealias ViewModel = PersonViewModel
    public typealias Delegate = AnyObject
    
    public weak var delegate: Delegate?
    
    private let backgroundCardView = UIView()
    
    private let personContentView = PersonContentView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        prepareSubviews()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(with viewModel: PersonViewModel) {
        
        personContentView.usernameLabel.text = "ovoant"
        personContentView.dateLabel.text = "Helping since December 2018"
        
        updateColors(for: theme)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        backgroundCardView.layer.cornerRadius = 4
        backgroundCardView.addShadow(forTheme: theme)
    }
    
    private func prepareSubviews() {
        contentView.addSubviews([backgroundCardView, personContentView])
        
        NSLayoutConstraint.activate([
            personContentView.topAnchor.constraint(equalTo: backgroundCardView.topAnchor, constant: 10),
            personContentView.leadingAnchor.constraint(equalTo: backgroundCardView.leadingAnchor, constant: 15),
            personContentView.trailingAnchor.constraint(equalTo: backgroundCardView.trailingAnchor, constant: -15),
            personContentView.bottomAnchor.constraint(equalTo: backgroundCardView.bottomAnchor, constant: -15),
            backgroundCardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            backgroundCardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            backgroundCardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            backgroundCardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }

}

// MARK: - Themeable

extension PersonTableViewCell: Themeable {
    func updateColors(for theme: Theme) {
        backgroundCardView.backgroundColor = .cellBackground(for: theme)
        contentView.backgroundColor = .background(for: theme)
    }
}
