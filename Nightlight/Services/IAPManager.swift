import StoreKit

public protocol IAPManaging {
    var iapManager: IAPManager { get }
}

public protocol IAPManagerDelegate: class {
    func iapManager(_ iapManager: IAPManager, didComplete transaction: SKPaymentTransaction)
    func iapManager(_ iapManager: IAPManager, didFail transaction: SKPaymentTransaction)
}

public class IAPManager: NSObject {
    private let productIdentifiers: [String]
    private var products = [SKProduct]()
    private var productRequest: SKProductsRequest?
    public let paymentQueue: SKPaymentQueue
    
    public weak var delegate: IAPManagerDelegate?
    
    init(skPaymentQueue: SKPaymentQueue = SKPaymentQueue.default(), productIdentifiers: [String]) {
        self.paymentQueue = skPaymentQueue
        self.productIdentifiers = productIdentifiers
        
        super.init()
        
        paymentQueue.add(self)
        loadProducts()
    }
    
    public class var canMakePayments: Bool {
        return SKPaymentQueue.canMakePayments()
    }
    
    public func purchase(_ productIdentifier: IAPIdentifier) {
        guard let product = products.first(where: { $0.productIdentifier == productIdentifier.fullIdentifier })
            else { return }
        
        paymentQueue.add(SKPayment(product: product))
    }
    
    private func loadProducts() {
        self.productRequest?.cancel()
        
        self.productRequest = SKProductsRequest(productIdentifiers: Set(productIdentifiers))
        self.productRequest?.delegate = self
        self.productRequest?.start()
    }
    
}

// MARK: - SKProductsRequestDelegate

extension IAPManager: SKProductsRequestDelegate {
    public func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        self.products = response.products
    }
}

// MARK: - SKPaymentTransactionObserver

extension IAPManager: SKPaymentTransactionObserver {
    public func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchased:
                print("purchased", transaction.transactionIdentifier)
                delegate?.iapManager(self, didComplete: transaction)
            case .failed:
                print("failed")
                delegate?.iapManager(self, didFail: transaction)
            case .deferred:
                print("deferred")
            case .purchasing:
                print("purchasing")
            case .restored:
                print("restored")
                
                break
            @unknown default: break
            }
        }
    }
    
}
