import UIKit

public class ProductCollectionViewCell: UICollectionViewCell, Configurable {
    public typealias ViewModel = ProductViewModel
    public typealias Delegate = AnyObject
    
    public weak var delegate: Delegate?
    
    private let tokenLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = .secondary14ptNormal
        return label
    }()
    
    private let priceTextView: UITextView = {
        let textView = UITextView()
        textView.font = .secondary14ptNormal
        textView.isScrollEnabled = false
        textView.isSelectable = false
        textView.isEditable = false
        textView.textContainerInset = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        textView.layer.cornerRadius = 4
        return textView
    }()
    
    public var productName: String = "" {
        didSet {
            updateTokenLabel()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.layer.borderColor = UIColor.brand.cgColor
        prepareSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.layer.cornerRadius = 4
        contentView.addShadow(forTheme: theme)
    }
    
    public func configure(with viewModel: ProductViewModel) {

        productName = viewModel.productName
        priceTextView.text = viewModel.productPrice
        subtitleLabel.text = viewModel.productDescription
        
        updateColors(for: theme)
    }
    
    public override var isSelected: Bool {
        didSet {
            contentView.layer.borderWidth = isSelected ? 2 : 0
        }
    }
    
    private func updateTokenLabel() {
        let string = NSMutableAttributedString(string: "")
        let font = UIFont.secondary16ptMedium
        
        let imageAttachment = TokenImageAttachment(font: font)
        imageAttachment.image = UIImage(named: "glyph_token")
        
        string.appendTokenAttachment(imageAttachment)
        
        string.append(NSAttributedString(string: "\(productName)"))
        
        tokenLabel.font = font
        tokenLabel.attributedText = string
    }
    
    private func prepareSubviews() {
        contentView.addSubviews([tokenLabel, priceTextView, subtitleLabel])
        
        NSLayoutConstraint.activate([
            tokenLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            tokenLabel.centerYAnchor.constraint(equalTo: priceTextView.centerYAnchor),
            priceTextView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            priceTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            subtitleLabel.leadingAnchor.constraint(equalTo: tokenLabel.leadingAnchor),
            subtitleLabel.topAnchor.constraint(equalTo: priceTextView.bottomAnchor, constant: 5),
            subtitleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }

}

// MARK: - Themeable

extension ProductCollectionViewCell: Themeable {
    func updateColors(for theme: Theme) {
        contentView.backgroundColor = .cellBackground(for: theme)
        tokenLabel.textColor = .primaryText(for: theme)
        priceTextView.backgroundColor = .brand
        subtitleLabel.textColor = .secondaryText
        priceTextView.textColor = UIColor.Palette.white
    }
}
