import UIKit

public class OnboardPageViewController: UIViewController, Themeable {
    typealias Dependencies = StyleManaging
    
    public var titleText: String?
    public var subtitleText: String?
    public var image: UIImage?
    
    public let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.primary20ptMedium
        return label
    }()
    
    public let subtitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        
        return label
    }()
    
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
        stackView.spacing = 50
        return stackView
    }()
    
    private let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        removeDidChangeThemeObserver()
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
        
        addDidChangeThemeObserver()
        prepareSubviews()
    }
    
    private func prepareSubviews() {
        textStackView.addArrangedSubviews([titleLabel, subtitleLabel])
        containerStackView.addArrangedSubviews([textStackView, imageView])
        view.addSubviews(containerStackView)
        
        NSLayoutConstraint.activate([
            containerStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            containerStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            containerStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageView.widthAnchor.constraint(equalTo: containerStackView.widthAnchor, multiplier: 0.70),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor)
        ])
        
        titleLabel.text = titleText
        subtitleLabel.text = subtitleText
        imageView.image = image
        
        updateColors(for: dependencies.styleManager.theme)
    }
    
    public func updateColors(for theme: Theme) {
        titleLabel.textColor = .primaryTextColor(for: theme)
        subtitleLabel.textColor = .secondaryTextColor
    }

}
