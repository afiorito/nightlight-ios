import UIKit

/// A view for displaying a prompt to send appreciation.
public class SendAppreciationView: UIView {

    /// A callback for when sending appreciation is cancelled.
    public var cancelAction: (() -> Void)? {
        didSet {
            headerView.cancelAction = cancelAction
        }
    }
    
    /// The number of tokens a person has.
    public var numTokens: Int = 0 {
        didSet {
            updateSubtitleLabel()
        }
    }
    
    /// A view for displaying send appreciation header.
    public let headerView: HeaderBarView = {
        let headerView = HeaderBarView()
        headerView.titleLabel.text = Strings.sendAppreciation
        
        return headerView
    }()
    
    /// A view for displaying the appreciation icon.
    private let appreciationImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage.icon.sunSelected
        return imageView
    }()
    
    /// A label for displaying the title.
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .primary20ptMedium
        label.text = Strings.sendAppreciation
        return label
    }()
    
    /// A label for displaying the description.
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = .secondary16ptNormal
        label.text = Strings.appreciationDescription
        return label
    }()
    
    /// A button for confirming an appreciation action.
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
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        
        prepareSubviews()
        updateSubtitleLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func prepareSubviews() {
        topContainer.addArrangedSubviews([appreciationImageView, titleLabel, descriptionLabel])
        container.addArrangedSubviews([topContainer, actionButton])
        addSubviews([headerView, container])
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: topAnchor),
            headerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            container.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 30),
            container.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
            container.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30),
            container.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -30),
            appreciationImageView.widthAnchor.constraint(equalToConstant: 50),
            appreciationImageView.heightAnchor.constraint(equalToConstant: 50),
            actionButton.widthAnchor.constraint(equalTo: container.widthAnchor, multiplier: 1.0)
        ])
    }
    
    /**
     Update the subtitle label to display the number of tokens with proper formatting.
     */
    private func updateSubtitleLabel() {
        let string = NSMutableAttributedString(string: "\(Strings.tokenCount): ")
        let font = UIFont.secondary14ptNormal
        
        let imageAttachment = TokenImageAttachment(font: font)
        imageAttachment.image = UIImage.glyph.token
        
        string.appendTokenAttachment(imageAttachment)
        string.append(NSAttributedString(string: "\(numTokens)"))
        
        headerView.subtitleLabel.font = font
        headerView.subtitleLabel.attributedText = string
    }
    
}

// MARK: - Themeable

extension SendAppreciationView: Themeable {
    func updateColors(for theme: Theme) {
        titleLabel.textColor = .label(for: theme)
        descriptionLabel.textColor = .secondaryLabel(for: theme)
        backgroundColor = .background(for: theme)
        headerView.updateColors(for: theme)
    }
}
