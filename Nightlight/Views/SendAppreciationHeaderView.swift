import UIKit

public class SendAppreciationHeaderView: UIView {
    public let cancelButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "icon_cancel"), for: .normal)
        return button
    }()
    
    public let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Send Appreciation"
        label.font = .primary16ptMedium
        return label
    }()
    
    public let subtitleLabel = UILabel()
    
    public let separatorLineView = UIView()
    
    private let textContainer: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        return stackView
    }()
    
    public var numTokens: Int = 0 {
        didSet {
            
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        prepareSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func prepareSubviews() {
        updateLabel()
        
        textContainer.addArrangedSubviews([titleLabel, subtitleLabel])
        addSubviews([cancelButton, textContainer, separatorLineView])
        
        NSLayoutConstraint.activate([
            cancelButton.centerYAnchor.constraint(equalTo: textContainer.centerYAnchor),
            cancelButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            textContainer.topAnchor.constraint(equalTo: topAnchor),
            textContainer.centerXAnchor.constraint(equalTo: centerXAnchor),
            separatorLineView.topAnchor.constraint(equalTo: textContainer.bottomAnchor, constant: 10),
            separatorLineView.heightAnchor.constraint(equalToConstant: 0.5),
            separatorLineView.leadingAnchor.constraint(equalTo: leadingAnchor),
            separatorLineView.trailingAnchor.constraint(equalTo: trailingAnchor),
            separatorLineView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func updateLabel() {
        let string = NSMutableAttributedString(string: "Token count: ")
        let font = UIFont.secondary14ptNormal
        
        let imageAttachment = TokenImageAttachment(font: font)
        imageAttachment.image = UIImage(named: "glyph_token")
        
        string.appendTokenAttachment(imageAttachment)
        string.append(NSAttributedString(string: "\(numTokens)"))
        
        subtitleLabel.font = font
        subtitleLabel.attributedText = string
        
    }
}

// MARK: - Themeable

extension SendAppreciationHeaderView: Themeable {
    func updateColors(for theme: Theme) {
        titleLabel.textColor = .primaryText(for: theme)
        subtitleLabel.textColor = .secondaryText
        cancelButton.tintColor = .neutral
        separatorLineView.backgroundColor = .border(for: theme)
    }
}
