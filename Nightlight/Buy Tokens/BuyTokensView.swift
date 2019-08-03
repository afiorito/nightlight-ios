import UIKit

public class BuyTokensView: UIView {
    
    public var cancelAction: (() -> Void)?
    public var confirmAction: (() -> Void)?
    
    private let cancelButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "icon_cancel"), for: .normal)
        return button
    }()
    
    public let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Token Packs"
        label.font = .primary16ptMedium
        return label
    }()
    
    public let confirmPurchaseButton: ContainedButton = {
        let button = ContainedButton()
        button.backgroundColor = .brand
        button.setTitle("Confirm Purchase", for: .normal)
        return button
    }()
    
    public let productsCollectionView: CompactCollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 15
        layout.minimumInteritemSpacing = 15
        let collectionView = CompactCollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(ProductCollectionViewCell.self, forCellWithReuseIdentifier: ProductCollectionViewCell.className)
        collectionView.contentInset = UIEdgeInsets(top: 15, left: 0, bottom: 15, right: 0)
        
        return collectionView
    }()
    
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
    
    @objc private func cancelTapped() {
        cancelAction?()
    }
    
    @objc private func confirmTapped() {
        confirmAction?()
    }
}

extension BuyTokensView: Themeable {
    func updateColors(for theme: Theme) {
        titleLabel.textColor = .primaryText(for: theme)
        cancelButton.tintColor = .neutral
        backgroundColor = .background(for: theme)
        productsCollectionView.backgroundColor = .background(for: theme)
    }
}
