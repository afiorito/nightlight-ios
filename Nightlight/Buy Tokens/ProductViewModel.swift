import StoreKit

/// A view model for handling product state.
public class ProductViewModel {
    typealias Dependencies = IAPManaging
    
    /// The backing product model.
    public let product: SKProduct
    
    /// The required dependencies.
    private let dependencies: Dependencies
    
    /// A formatter for displaying proper currency.
    private static var formatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter
    }
    
    /// The name of the product.
    var productName: String {
        return product.localizedTitle
    }
    
    /// The price of the product.
    var productPrice: String {
        Self.formatter.locale = product.priceLocale
        return Self.formatter.string(from: product.price) ?? "-"
    }
    
    /// The description of the product.
    var productDescription: String {
        return product.localizedDescription
    }
    
    init(dependencies: Dependencies, product: SKProduct) {
        self.product = product
        self.dependencies = dependencies
    }
    
    /**
     Purchase tokens by initiating in-app purchase.
     */
    public func purchaseProduct() {
        dependencies.iapManager.purchase(product: product)
    }
}
