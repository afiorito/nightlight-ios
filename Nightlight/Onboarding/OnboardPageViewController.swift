import UIKit

/// A view controller for managing an onboarding page.
public class OnboardPageViewController: UIViewController {
    /// A string representing the page title.
    public var titleText: String?
    
    /// A string representing the page subtitle.
    public var subtitleText: String?
    
    /// A string representing the page image.
    public var image: UIImage?
    
    /// A label for displaying the page title.
    public let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.primary20ptMedium
        return label
    }()
    
    /// A label for displaying the page subtitle.
    public let subtitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        
        return label
    }()
    
    /// A label for displaying the page image.
    public let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    private let textStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 4
        return stackView
    }()
    
    private let containerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        return stackView
    }()

    override public func viewDidLoad() {
        super.viewDidLoad()
        
        addDidChangeThemeObserver()
        prepareSubviews()
        updateColors(for: theme)
    }
    
    private func prepareSubviews() {
        textStackView.addArrangedSubviews([titleLabel, subtitleLabel])
        containerStackView.addArrangedSubviews([UIView(), textStackView, imageView, UIView()])
        view.addSubviews(containerStackView)
        
        let widthConstraint = imageView.widthAnchor.constraint(equalTo: containerStackView.widthAnchor, multiplier: 0.70)
        widthConstraint.priority = .required - 1
        
        NSLayoutConstraint.activate([
            containerStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            containerStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            containerStackView.topAnchor.constraint(equalTo: view.topAnchor),
            containerStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            imageView.widthAnchor.constraint(lessThanOrEqualToConstant: 375),
            widthConstraint,
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor)
        ])
        
        titleLabel.text = titleText
        subtitleLabel.text = subtitleText
        imageView.image = image
    }
    
    deinit {
        removeDidChangeThemeObserver()
    }

}

// MARK: - Themeable

extension OnboardPageViewController: Themeable {
    public func updateColors(for theme: Theme) {
        titleLabel.textColor = .primaryText(for: theme)
        subtitleLabel.textColor = .secondaryText(for: theme)
    }
}
