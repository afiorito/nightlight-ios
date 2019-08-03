import StoreKit

public class BuyTokensViewModel {
    typealias Dependencies = IAPManaging
    
    private let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
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
