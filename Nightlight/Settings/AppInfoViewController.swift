import UIKit

/// A view controller for managing app information.
public class AppInfoViewController: UIViewController {
    /// The viewModel for handling state.
    private let viewModel: AppInfoViewModel
    
    /// A button for dismissing the app information.
    private let cancelButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage.icon.cancel, for: .normal)
        return button
    }()
    
    /// An image view for displaying the logo icon.
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage.icon.logo
        imageView.tintColor = .brand
        return imageView
    }()
    
    /// A label for displaying the app version.
    private lazy var versionLabel: UILabel = {
        let label = UILabel()
        label.font = .primary20ptMedium
        label.text = "Nightlight v\(viewModel.versionNumber) \(viewModel.buildNumber)"
        label.textAlignment = .center
        return label
    }()
    
    /// A label for displaying extra information.
    private lazy var infoLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .primary16ptNormal
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 3
        paragraphStyle.alignment = .center

        let string = NSMutableAttributedString(string: """
        By Anthony Fiorito
        © \(viewModel.copyrightDate) Electriapp
        Made in Montreal 🇨🇦
        """)

        string.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: string.length))
        label.attributedText = string
        return label
    }()
    
    /// A label for displaying a special thanks.
    private let thanksLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .primary12ptNormal
        label.textAlignment = .center
        label.text = "A special thanks to my best friend and partner mg for her undying love and support."
        return label
    }()
    
    // MARK: - Stack View Containers
    
    private let container: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 20
        
        return stackView
    }()
    
    private let textContainer: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 3
        return stackView
    }()
    
    public init(viewModel: AppInfoViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        cancelButton.addTarget(self, action: #selector(hideInfo), for: .touchUpInside)
        
        prepareSubviews()
        updateColors(for: theme)
    }
    
    private func prepareSubviews() {
        textContainer.addArrangedSubviews([versionLabel, infoLabel])
        container.addArrangedSubviews([logoImageView, textContainer])
        view.addSubviews([cancelButton, container, thanksLabel])
        
        NSLayoutConstraint.activate([
            cancelButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 15),
            cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            container.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            container.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            container.topAnchor.constraint(equalTo: cancelButton.bottomAnchor, constant: 15),
            container.bottomAnchor.constraint(lessThanOrEqualTo: thanksLabel.topAnchor, constant: -30),
            logoImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.3),
            logoImageView.heightAnchor.constraint(equalTo: logoImageView.widthAnchor, multiplier: 1.0),
            thanksLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -15),
            thanksLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            thanksLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15)
        ])
    }
    
    @objc private func hideInfo() {
        dismiss(animated: true)
    }
}

// MARK: - Themeable

extension AppInfoViewController: Themeable {
    func updateColors(for theme: Theme) {
        view.backgroundColor = .background(for: theme)
        cancelButton.tintColor = .gray(for: theme)
        versionLabel.textColor = .primaryText(for: theme)
        infoLabel.textColor = .primaryText(for: theme)
        thanksLabel.textColor = .primaryText(for: theme)
    }
}

// MARK: - Modal Presentable

extension AppInfoViewController: ModalPresentable {
    public var height: ModalHeight {
        return .intrinsicHeight
    }
    
}
