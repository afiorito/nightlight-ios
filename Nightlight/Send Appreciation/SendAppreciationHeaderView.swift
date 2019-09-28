import UIKit

/// A view for displaying send appreciation header information.
public class SendAppreciationHeaderView: UIView {
    /// A button for cancelling sending appreciation.
    public let cancelButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage.icon.cancel, for: .normal)
        return button
    }()
    
    /// A label for displaying the header title.
    public let titleLabel: UILabel = {
        let label = UILabel()
        label.text = Strings.sendAppreciation
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
    
    /// The number of tokens a person has.
    public var numTokens: Int = 0 {
        didSet {
            updateSubtitleLabel()
        }
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)

        prepareSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func prepareSubviews() {
        updateSubtitleLabel()
        
        textContainer.addArrangedSubviews([titleLabel, subtitleLabel])
        addSubviews([cancelButton, textContainer, separatorLineView])
        
        NSLayoutConstraint.activate([
            cancelButton.centerYAnchor.constraint(equalTo: textContainer.centerYAnchor),
            cancelButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            textContainer.topAnchor.constraint(equalTo: topAnchor),
            textContainer.centerXAnchor.constraint(equalTo: centerXAnchor),
            separatorLineView.topAnchor.constraint(equalTo: textContainer.bottomAnchor, constant: 10),
            separatorLineView.heightAnchor.constraint(equalToConstant: 1 / UIScreen.main.scale),
            separatorLineView.leadingAnchor.constraint(equalTo: leadingAnchor),
            separatorLineView.trailingAnchor.constraint(equalTo: trailingAnchor),
            separatorLineView.bottomAnchor.constraint(equalTo: bottomAnchor)
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
        
        subtitleLabel.font = font
        subtitleLabel.attributedText = string
    }
}

// MARK: - Themeable

extension SendAppreciationHeaderView: Themeable {
    func updateColors(for theme: Theme) {
        titleLabel.textColor = .label(for: theme)
        subtitleLabel.textColor = .secondaryLabel(for: theme)
        cancelButton.tintColor = .gray(for: theme)
        separatorLineView.backgroundColor = .separator(for: theme)
    }
}
