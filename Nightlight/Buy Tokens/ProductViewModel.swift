import StoreKit

public class ProductViewModel {
    typealias Dependencies = IAPManaging
    
    public let product: SKProduct
    
    private let dependencies: Dependencies
    
    private static var formatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        
        return formatter
    }
    
    init(dependencies: Dependencies, product: SKProduct) {
        self.product = product
        self.dependencies = dependencies
    }
    
    var productName: String {
        return product.localizedTitle
    }
    
    var productPrice: String {
        Self.formatter.locale = product.priceLocale
        return Self.formatter.string(from: product.price) ?? "-"
    }
    
    var productDescription: String {
        return product.localizedDescription
    }
    
    public func purchaseProduct() {
        dependencies.iapManager.purchase(product: product)
    }
}
