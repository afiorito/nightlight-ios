import UIKit

public class SendAppreciationView: UIView {

    public var cancelAction: (() -> Void)?
    
    public let headerView = SendAppreciationHeaderView()
    
    private let appreciationImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage.icon.sunSelected
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .primary20ptMedium
        label.text = "Send Appreciation"
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = .secondary16ptNormal
        label.text = "Let’s the person know you appreciate them and increases the appreciation on their message."
        return label
    }()
    
    public let actionButton: ContainedButton = {
        let button = ContainedButton()
        button.backgroundColor = .brand
        return button
    }()
    
    private let container: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.spacing = 30
        
        return stackView
    }()
    
    private let topContainer: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 10
        
        return stackView
    }()
    
    public var numTokens: Int {
        get { return headerView.numTokens }
        set { headerView.numTokens = newValue }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        headerView.cancelButton.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)
        
        prepareSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func prepareSubviews() {
        topContainer.addArrangedSubviews([appreciationImageView, titleLabel, descriptionLabel])
        container.addArrangedSubviews([topContainer, actionButton])
        addSubviews([headerView, container])
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            headerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            container.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 15) ,
            container.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
            container.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30),
            container.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -30),
            appreciationImageView.widthAnchor.constraint(equalToConstant: 50),
            appreciationImageView.heightAnchor.constraint(equalToConstant: 50),
            actionButton.widthAnchor.constraint(equalTo: container.widthAnchor, multiplier: 1.0)
        ])
    }

    @objc private func cancelTapped() {
        cancelAction?()
    }
    
}

// MARK: - Themeable

extension SendAppreciationView: Themeable {
    func updateColors(for theme: Theme) {
        titleLabel.textColor = .primaryText(for: theme)
        descriptionLabel.textColor = .secondaryText
        backgroundColor = .background(for: theme)
        headerView.updateColors(for: theme)
    }
}
