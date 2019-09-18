import UIKit

/// A view controller for handling the purchase of tokens.
public class BuyTokensViewController: UIViewController, ModalPresentable {
    /// The view that the `BuyTokensViewController` manages.
    private var buyTokensView = BuyTokensView()
    
    /// The viewModel for handling state.
    private let viewModel: BuyTokensViewModel
    
    public init(viewModel: BuyTokensViewModel) {
        self.viewModel = viewModel
        
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
        
        buyTokensView.confirmAction = { [weak self] in
            self?.confirmPurchase()
        }
        
        buyTokensView.productsCollectionView.delegate = self
        buyTokensView.productsCollectionView.dataSource = self
        
        if !viewModel.canMakePayments {
            buyTokensView.confirmPurchaseButton.setTitle(Strings.unavailableButtonText, for: .normal)
            buyTokensView.confirmPurchaseButton.isEnabled = false
        }
        
        prepareSubviews()
        updateColors(for: theme)
        
        if viewModel.productsCount > 0 {
            buyTokensView.productsCollectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: true, scrollPosition: .centeredHorizontally)
        }
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
    
    /**
     Confirm the selected purchase.
     */
    private func confirmPurchase() {
        guard let indexPath = buyTokensView.productsCollectionView.indexPathsForSelectedItems?.first
            else { return }
        
        buyTokensView.confirmPurchaseButton.isLoading = true
        viewModel.purchaseProduct(at: indexPath)
    }

}

// MARK: - SendAppreciationViewModel UI Delegate

extension BuyTokensViewController: BuyTokensViewModelUIDelegate {
    public func didBeginFetchingProducts() {
        buyTokensView.confirmPurchaseButton.isEnabled = false
    }
    
    public func didEndFetchingProducts() {}
    
    public func didFailToFetchProducts(with error: Error) {
        buyTokensView.noProductsFoundLabel.isHidden = false
    }
    
    public func didFetchProducts() {
        buyTokensView.productsCollectionView.reloadData()
        buyTokensView.confirmPurchaseButton.isEnabled = true
    }
    
    public func didCancelTransaction() {
        buyTokensView.confirmPurchaseButton.isEnabled = true
        buyTokensView.confirmPurchaseButton.isLoading = false
    }
}

// MARK: - UICollectionView DataSource

extension BuyTokensViewController: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.productsCount
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCollectionViewCell.className,
                                                      for: indexPath) as! ProductCollectionViewCell
        
        cell.configure(with: viewModel.productViewModel(at: indexPath))
        return cell
    }
    
}

// MARK: - UICollectionView Delegate

extension BuyTokensViewController: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width - 30, height: 100.0)
    }
}

// MARK: - Themeable

extension BuyTokensViewController: Themeable {
    var theme: Theme {
        return viewModel.theme
    }

    func updateColors(for theme: Theme) {
        buyTokensView.updateColors(for: theme)
    }
}
