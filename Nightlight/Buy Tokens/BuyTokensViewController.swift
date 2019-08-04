import UIKit

public class BuyTokensViewController: UIViewController {
    
    private var buyTokensView = BuyTokensView()
    
    private let viewModel: BuyTokensViewModel
    
    private let products: [ProductViewModel]
    
    init(viewModel: BuyTokensViewModel, products: [ProductViewModel]) {
        self.viewModel = viewModel
        self.products = products
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()

        buyTokensView.cancelAction = { [weak self] in
            self?.dismiss(animated: true)
        }
        
        buyTokensView.confirmAction = purchaseProduct
        
        buyTokensView.productsCollectionView.delegate = self
        buyTokensView.productsCollectionView.dataSource = self
        
        if !IAPManager.canMakePayments {
            buyTokensView.confirmPurchaseButton.setTitle("Unavailable", for: .normal)
            buyTokensView.confirmPurchaseButton.isEnabled = false
        }
        
        prepareSubviews()
        updateColors(for: theme)
        
        buyTokensView.productsCollectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: true, scrollPosition: .centeredHorizontally)
    }

    private func prepareSubviews() {
        view.addSubviews(buyTokensView)
        
        NSLayoutConstraint.activate([
            buyTokensView.topAnchor.constraint(equalTo: view.topAnchor),
            buyTokensView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            buyTokensView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            buyTokensView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func purchaseProduct() {
        guard let indexPath = buyTokensView.productsCollectionView.indexPathsForSelectedItems?.first else {
            return
        }
        
        buyTokensView.confirmPurchaseButton.isEnabled = false
        buyTokensView.confirmPurchaseButton.isLoading = true
        
        let product = products[indexPath.row]
        product.purchaseProduct()
    }

}

extension BuyTokensViewController {
    func didCancelTransaction() {
        buyTokensView.confirmPurchaseButton.isEnabled = true
        buyTokensView.confirmPurchaseButton.isLoading = false
    }
}

// MARK: - UICollectionView DataSource

extension BuyTokensViewController: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCollectionViewCell.className,
                                                      for: indexPath) as! ProductCollectionViewCell
        
        cell.configure(with: products[indexPath.row])
        
        return cell
    }
    
}

// MARK: - UICollectionView Delegate

extension BuyTokensViewController: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width - 30, height: 50)
    }
}

// MARK: - Themeable

extension BuyTokensViewController: Themeable {
    func updateColors(for theme: Theme) {
        buyTokensView.updateColors(for: theme)
    }
}
