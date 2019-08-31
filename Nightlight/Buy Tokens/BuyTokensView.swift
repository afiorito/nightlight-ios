import UIKit

/// A view with elements for purchasing tokens.
public class BuyTokensView: UIView {
    
    /// A handler for notifying when a purchasing is cancelled.
    public var cancelAction: (() -> Void)?
    
    /// A handler for notifying when a purchase is confirmed.
    public var confirmAction: (() -> Void)?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        if let layout = productsCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.estimatedItemSize = CGSize(width: productsCollectionView.frame.width, height: UICollectionViewFlowLayout.automaticSize.height)
        }
        
        cancelButton.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)
        confirmPurchaseButton.addTarget(self, action: #selector(confirmTapped), for: .touchUpInside)
        
        prepareSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// A button for cancelling the purchase.
    private let cancelButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage.icon.cancel, for: .normal)
        return button
    }()
    
    /// A label for displaying the title.
    public let titleLabel: UILabel = {
        let label = UILabel()
        label.text = Strings.tokenPacksTitle
        label.font = .primary16ptMedium
        return label
    }()
    
    /// A button for confirming the purchase.
    public let confirmPurchaseButton: ContainedButton = {
        let button = ContainedButton()
        button.backgroundColor = .brand
        button.setTitle(Strings.confirmPurchaseButtonText, for: .normal)
        return button
    }()
    
    /// A collection view for displaying products.
    public let productsCollectionView: CompactCollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 15
        layout.minimumInteritemSpacing = 15
        let collectionView = CompactCollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(ProductCollectionViewCell.self, forCellWithReuseIdentifier: ProductCollectionViewCell.className)
        collectionView.contentInset = UIEdgeInsets(top: 15, left: 0, bottom: 15, right: 0)
        
        return collectionView
    }()
    
    private func prepareSubviews() {
        addSubviews([cancelButton, titleLabel, productsCollectionView, confirmPurchaseButton])
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            cancelButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            cancelButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            productsCollectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            productsCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            productsCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            confirmPurchaseButton.topAnchor.constraint(equalTo: productsCollectionView.bottomAnchor),
            confirmPurchaseButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            confirmPurchaseButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            confirmPurchaseButton.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -15)
        ])
    }
    
    /**
     Handle a cancel button tap event.
     */
    @objc private func cancelTapped() {
        cancelAction?()
    }
    
    /**
    Handle a confirm button tap event.
    */
    @objc private func confirmTapped() {
        confirmAction?()
    }
}

// MARK: - Themeable

extension BuyTokensView: Themeable {
    func updateColors(for theme: Theme) {
        titleLabel.textColor = .primaryText(for: theme)
        cancelButton.tintColor = .gray(for: theme)
        backgroundColor = .background(for: theme)
        productsCollectionView.backgroundColor = .background(for: theme)
    }
}
