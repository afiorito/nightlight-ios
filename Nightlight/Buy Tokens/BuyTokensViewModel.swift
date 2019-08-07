import StoreKit

/// A view model for handling purchasing tokens state.
public class BuyTokensViewModel {
    typealias Dependencies = IAPManaging & StyleManaging
    
    /// The required dependencies.
    private let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
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
     Retrieve a list of available products.
     - parameter result: The products result.
     */
    public func getProducts(result: @escaping (Result<[ProductViewModel], Error>) -> Void) {
        dependencies.iapManager.requestProducts { productResult in
            switch productResult {
            case .success(let products):
                result(.success(products.map { ProductViewModel(dependencies: self.dependencies, product: $0) }))
            case .failure(let error):
                result(.failure(error))
            }
        }
    }
}
