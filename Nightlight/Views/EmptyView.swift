import UIKit

/// A placeholder view for empty content.
public class EmptyView: UIView {
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        prepareSubviews()
    }
    
    convenience init(description: EmptyViewDescription) {
        self.init(frame: .zero)
        self.image = description.image
        self.title = description.title
        self.subtitle = description.subtitle
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Subviews & Layout
    
    private let container: UIStackView = {
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
        label.font = .secondary16ptNormal
        return label
    }()
    
    /// The name of the image without light or dark suffix.
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
    
    private func prepareSubviews() {
        textContainer.addArrangedSubviews([titleLabel, subtitleLabel])
        container.addArrangedSubviews([imageView, textContainer])
        addSubviews(container)
        
        NSLayoutConstraint.activate([
            container.centerXAnchor.constraint(equalTo: centerXAnchor),
            container.centerYAnchor.constraint(equalTo: centerYAnchor),
            imageView.widthAnchor.constraint(equalTo: widthAnchor),
            imageView.heightAnchor.constraint(equalTo: imageView.heightAnchor)
        ])
    }
}

// MARK: - Themeable

extension EmptyView: Themeable {
    public func updateColors(for theme: Theme) {
        titleLabel.textColor = .primaryText(for: theme)
        subtitleLabel.textColor = .secondaryText
    }
}
