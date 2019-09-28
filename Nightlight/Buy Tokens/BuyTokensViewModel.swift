import StoreKit

/// A view model for handling purchasing tokens state.
public class BuyTokensViewModel {
    public typealias Dependencies = IAPManaging & StyleManaging
    
    /// The required dependencies.
    private let dependencies: Dependencies
    
    /// The delegate object that handles user interface updates.
    public weak var uiDelegate: BuyTokensViewModelUIDelegate?
    
    /// The delegate object that handles navigation events.
    public weak var navigationDelegate: BuyTokensNavigationDelegate?
    
    /// The fetched products.
    private var products = [SKProduct]()
    
    public init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    /// The count for fetched products.
    public var productsCount: Int {
        return products.count
    }
    
    /// The active theme.
    public var theme: Theme {
        return dependencies.styleManager.theme
    }
    
    /// A boolean denoting if the device can make payments.
    public var canMakePayments: Bool {
        return IAPManager.canMakePayments
    }
    
    /**
     Returns a product as a `ProductViewModel` at a specified indexPath.
     
     - parameter indexPath: The index path for the product.
     */
    public func productViewModel(at indexPath: IndexPath) -> ProductViewModel {
        return ProductViewModel(product: products[indexPath.row], dependencies: dependencies)
    }
    
    /**
     Retrieve a list of available products.
     - parameter completion: A block that is called when products are finished being fetched.
     */
    public func fetchProducts(completion: (() -> Void)? = nil) {
        uiDelegate?.didBeginFetchingProducts()
        
        dependencies.iapManager.requestProducts { [weak self] productResult in
            guard let self = self else { return }

            DispatchQueue.main.async {
                self.uiDelegate?.didEndFetchingProducts()
            }

            switch productResult {
            case .success(let products):
                if products.isEmpty {
                    DispatchQueue.main.async {
                        self.uiDelegate?.didFailToFetchProducts(with: ProductError.noProductsFound)
                        completion?()
                    }
                    return
                }
                
                self.products = products
                DispatchQueue.main.async { self.uiDelegate?.didFetchProducts() }
            case .failure(let error):
                DispatchQueue.main.async { self.uiDelegate?.didFailToFetchProducts(with: error) }
            }
            
            DispatchQueue.main.async { completion?() }
        }
    }
    
    /**
     Start a purchase for a product at a specified indexPath.
     
     - parameter indexPath: The index path of the product.
     */
    public func purchaseProduct(at indexPath: IndexPath) {
        dependencies.iapManager.purchase(product: products[indexPath.row])
    }
    
    /**
     Stop buying tokens.
     */
    public func finish() {
        navigationDelegate?.didFinishBuyingTokens()
    }
}

// MARK: - Navigation Events

extension BuyTokensViewModel {
    public func didCancelTransaction() {
        uiDelegate?.didCancelTransaction()
    }
}
