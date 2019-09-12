import StoreKit

public protocol IAPManaging {
    var iapManager: IAPManager { get }
}

/// Handles operations for in-app purchases.
public class IAPManager: NSObject {
    public typealias Dependencies = PeopleServiced & KeychainManaging
    public typealias ProductsRequestCompletionHandler = (Result<[SKProduct], Error>) -> Void

    /// A constant for denoting a transaction outcome.
    public enum TransactionOutcome {
        case success
        case cancelled
        case failed
    }
    
    /// The required dependencies.
    private let dependencies: Dependencies
    
    /// The list of product identifiers to load.
    private let productIdentifiers: [String]
    
    /// The current request for products from the product identifiers.
    private var productsRequest: SKProductsRequest?
    
    /// A callback for product requesting.
    private var productsRequestCompletionHandler: ProductsRequestCompletionHandler?
    
    /// The payment queue for handling purchases.
    private let paymentQueue: SKPaymentQueue
    
    init(productIdentifiers: [String], skPaymentQueue: SKPaymentQueue = SKPaymentQueue.default(), dependencies: Dependencies) {
        self.paymentQueue = skPaymentQueue
        self.productIdentifiers = productIdentifiers
        self.dependencies = dependencies
        
        super.init()
        
        paymentQueue.add(self)
    }
    
    /// A boolean denoting if a user's device can make payments.
    public class var canMakePayments: Bool {
        return SKPaymentQueue.canMakePayments()
    }
    
    /**
     Purchase a product.
     
     - parameter product: the product to purchase.
     */
    public func purchase(product: SKProduct) {
        paymentQueue.add(SKPayment(product: product))
    }
    
    /**
     Request products.
     
     - parameter result: the result of requesting products.
     */
    public func requestProducts(result: @escaping ProductsRequestCompletionHandler) {
        self.productsRequest?.cancel()
        
        productsRequestCompletionHandler = result
        self.productsRequest = SKProductsRequest(productIdentifiers: Set(productIdentifiers))
        self.productsRequest?.delegate = self
        self.productsRequest?.start()
    }
    
    /**
     Reset the products request.
     */
    private func clearRequest() {
        productsRequest = nil
        productsRequestCompletionHandler = nil
    }
    
}

// MARK: - SKProductsRequestDelegate

extension IAPManager: SKProductsRequestDelegate {
    public func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        productsRequestCompletionHandler?(.success(response.products))
        clearRequest()
    }
    
    public func request(_ request: SKRequest, didFailWithError error: Error) {
        productsRequestCompletionHandler?(.failure(error))
        clearRequest()
    }
}

// MARK: - SKPaymentTransactionObserver

extension IAPManager: SKPaymentTransactionObserver {
    public func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchased:
                complete(transaction: transaction)
            case .failed:
                NLNotification.didFinishTransaction.post(object: transaction, userInfo: TransactionOutcome.cancelled)
                paymentQueue.finishTransaction(transaction)
            default: break
            }
        }
    }
    
    private func complete(transaction: SKPaymentTransaction) {
        guard let tokens = Int(String(transaction.payment.productIdentifier.split(separator: "_")[1])) else {
            return
        }

        dependencies.peopleService.addTokens(tokens: tokens) { [weak self] result in
            switch result {
            case .success(let tokens):
                try? self?.dependencies.keychainManager.set(tokens, forKey: KeychainKey.tokens.rawValue)
                NLNotification.didFinishTransaction.post(object: transaction, userInfo: TransactionOutcome.success)
                self?.paymentQueue.finishTransaction(transaction)
            case .failure:
                NLNotification.didFinishTransaction.post(object: transaction, userInfo: TransactionOutcome.failed)
                
            }
        }
    }
    
}
