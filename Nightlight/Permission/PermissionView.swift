import UIKit

public class PermissionView: UIView {
    
    public var confirmAction: (() -> Void)?
    
    public var cancelAction: (() -> Void)?
    
    /// Name of the image without light or dark prefix.
    public var imageName: String?
    
    /// Title text for the permission.
    public var title: String? {
        get { return titleLabel.text }
        set { titleLabel.text = newValue }
    }
    
    public var confirmActionTitle: String? {
        get { return confirmButton.titleLabel?.text }
        set { confirmButton.setTitle(newValue, for: .normal) }
    }
    
    public var cancelActionTitle: String? {
        get { return cancelButton.titleLabel?.text }
        set { cancelButton.setTitle(newValue, for: .normal) }
    }
    
    /// The subtitle text for the permission.
    public var subtitle: String? {
        get { return subtitleLabel.text }
        set { subtitleLabel.text = newValue }
    }
    
    private var image: UIImage? {
        get { return imageView.image }
        set { imageView.image = newValue }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        confirmButton.addTarget(self, action: #selector(confirmTapped), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)
        
        prepareSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Subviews & Layout
    
    private let container: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        
        return stackView
    }()
    
    private let topContainer: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 30
        
        return stackView
    }()
    
    private let textContainer: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 5
        
        return stackView
    }()
    
    private let buttonContainer: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 10
        
        return stackView
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .primary20ptMedium
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = .secondary16ptNormal
        return label
    }()
    
    private let confirmButton: ContainedButton = {
        let button = ContainedButton()
        button.backgroundColor = .brand
        return button
    }()
    
    private let cancelButton = TextButton()
    
    @objc private func cancelTapped() {
        cancelAction?()
    }
    
    @objc private func confirmTapped() {
        confirmAction?()
    }
    
    private func prepareSubviews() {
        textContainer.addArrangedSubviews([titleLabel, subtitleLabel])
        topContainer.addArrangedSubviews([imageView, textContainer])
        buttonContainer.addArrangedSubviews([confirmButton, cancelButton])
        container.addArrangedSubviews([UIView(), UIView(), topContainer, UIView(), buttonContainer, UIView()])
        addSubviews([container])
        
        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: topAnchor),
            container.bottomAnchor.constraint(equalTo: bottomAnchor),
            container.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
            container.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30),
            imageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.75),
            imageView.heightAnchor.constraint(equalTo: imageView.heightAnchor)
        ])
    }
}

// MARK: - Themeable

extension PermissionView: Themeable {
    public func updateColors(for theme: Theme) {
        backgroundColor = .background(for: theme)
        titleLabel.textColor = .primaryText(for: theme)
        subtitleLabel.textColor = .secondaryText
        cancelButton.setTitleColor(.secondaryText, for: .normal)
        
        if let imageName = imageName {
            switch theme {
            case.light:
                image = UIImage(named: "\(imageName)_light")
            case .dark:
                image = UIImage(named: "\(imageName)_dark")
            }
        }
    }
}
