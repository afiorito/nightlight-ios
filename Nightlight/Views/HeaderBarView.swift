import UIKit

/// A header view for modally presented view controllers without a navigation controller.
public class HeaderBarView: UIView {
    
    /// A callback for the cancel action.
    public var cancelAction: (() -> Void)?
    
    /// A button for cancelling sending appreciation.
    public let cancelButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage.icon.cancel, for: .normal)
        return button
    }()
    
    /// A label for displaying the header title.
    public let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .primary16ptMedium
        return label
    }()
    
    /// A label for displaying the header subtitle.
    public let subtitleLabel = UILabel()
    
    /// A view for displaying a bottom header separator.
    public let separatorLineView = UIView()
    
    private let textContainer: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        return stackView
    }()
    
    override public init(frame: CGRect) {
        super.init(frame: frame)

        prepareSubviews()
        cancelButton.addTarget(self, action: #selector(cancel), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func prepareSubviews() {
        textContainer.addArrangedSubviews([titleLabel, subtitleLabel])
        addSubviews([cancelButton, textContainer, separatorLineView])
        
        NSLayoutConstraint.activate([
            cancelButton.centerYAnchor.constraint(equalTo: textContainer.centerYAnchor),
            cancelButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            textContainer.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            textContainer.centerXAnchor.constraint(equalTo: centerXAnchor),
            separatorLineView.topAnchor.constraint(equalTo: textContainer.bottomAnchor, constant: 12),
            separatorLineView.heightAnchor.constraint(equalToConstant: 1 / UIScreen.main.scale),
            separatorLineView.leadingAnchor.constraint(equalTo: leadingAnchor),
            separatorLineView.trailingAnchor.constraint(equalTo: trailingAnchor),
            separatorLineView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    @objc private func cancel() {
        cancelAction?()
    }
}

// MARK: - Themeable

extension HeaderBarView: Themeable {
    func updateColors(for theme: Theme) {
        titleLabel.textColor = .label(for: theme)
        subtitleLabel.textColor = .secondaryLabel(for: theme)
        cancelButton.tintColor = .gray(for: theme)
        separatorLineView.backgroundColor = .separator(for: theme)
    }
}
