import UIKit

/// A placeholder view for empty content.
public class EmptyView: UIView {
    /// The empty image.
    public var image: UIImage? {
        get { return imageView.image }
        set { imageView.image = newValue }
    }
    
    /// The title text for the empty placeholder.
    public var title: String? {
        get { return titleLabel.text }
        set { titleLabel.text = newValue }
    }
    
    /// The subtitle text for the empty placeholder
    public var subtitle: String? {
        get { return subtitleLabel.text }
        set { subtitleLabel.text = newValue }
    }

    required public init(description: EmptyViewDescription) {
        super.init(frame: .zero)
        self.image = UIImage(named: description.imageName)
        self.title = description.title
        self.subtitle = description.subtitle
        
        prepareSubviews()
        updateColors(for: theme)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Subviews & Layout
    
    /// An image view for displaying the empty image.
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    /// A label for displaying the title.
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .primary20ptMedium
        return label
    }()
    
    /// A label for displaying the subtitle.
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = .secondary16ptNormal
        return label
    }()
    
    private let container: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 32
        
        return stackView
    }()
    
    private let textContainer: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 5
        
        return stackView
    }()
    
    private func prepareSubviews() {
        textContainer.addArrangedSubviews([titleLabel, subtitleLabel])
        container.addArrangedSubviews([imageView, textContainer])
        addSubviews(container)
        
        let widthConstraint = imageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5)
        widthConstraint.priority = .required - 1
        
        NSLayoutConstraint.activate([
            container.centerYAnchor.constraint(equalTo: centerYAnchor),
            container.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
            container.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30),
            imageView.widthAnchor.constraint(lessThanOrEqualToConstant: 250),
            widthConstraint,
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor)
        ])
    }
}

// MARK: - Themeable

extension EmptyView: Themeable {
    public func updateColors(for theme: Theme) {
        titleLabel.textColor = .label(for: theme)
        subtitleLabel.textColor = .secondaryLabel(for: theme)
    }
}
