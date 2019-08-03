import StoreKit

public protocol IAPManaging {
    var iapManager: IAPManager { get }
}

public class IAPManager: NSObject {
    public typealias Dependencies = PeopleServiced & KeychainManaging
    public typealias ProductsRequestCompletionHandler = (Result<[SKProduct], Error>) -> Void

    public enum TransactionOutcome {
        case success
        case cancelled
        case failed
    }
    
    public var dependencies: Dependencies?
    
    private let productIdentifiers: [String]
    private var productsRequest: SKProductsRequest?
    private var productsRequestCompletionHandler: ProductsRequestCompletionHandler?
    private let paymentQueue: SKPaymentQueue
    
    init(productIdentifiers: [String], skPaymentQueue: SKPaymentQueue = SKPaymentQueue.default()) {
        self.paymentQueue = skPaymentQueue
        self.productIdentifiers = productIdentifiers
        
        super.init()
        
        paymentQueue.add(self)
    }
    
    public class var canMakePayments: Bool {
        return SKPaymentQueue.canMakePayments()
    }
    
    public func purchase(product: SKProduct) {
        paymentQueue.add(SKPayment(product: product))
    }
    
    public func requestProducts(result: @escaping ProductsRequestCompletionHandler) {
        self.productsRequest?.cancel()
        
        productsRequestCompletionHandler = result
        self.productsRequest = SKProductsRequest(productIdentifiers: Set(productIdentifiers))
        self.productsRequest?.delegate = self
        self.productsRequest?.start()
    }
    
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

        dependencies?.peopleService.addTokens(tokens: tokens) { [weak self] result in
            switch result {
            case .success(let tokens):
                try? self?.dependencies?.keychainManager.set(tokens, forKey: KeychainKey.tokens.rawValue)
                NLNotification.didFinishTransaction.post(object: transaction, userInfo: TransactionOutcome.success)
                self?.paymentQueue.finishTransaction(transaction)
            case .failure:
                NLNotification.didFinishTransaction.post(object: transaction, userInfo: TransactionOutcome.failed)
                
            }
        }
    }
    
}
