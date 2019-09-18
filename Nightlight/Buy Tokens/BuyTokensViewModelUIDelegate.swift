/// Methods for updating the user interface from a `BuyTokensViewModel`.
public protocol BuyTokensViewModelUIDelegate: class {
    /**
     Tells the delegate that fetching products began.
     */
    func didBeginFetchingProducts()
    
    /**
     Tells the delegate that fetching products stopped.
     */
    func didEndFetchingProducts()
    
    /**
     Tells the delegate that products fetched successfully.
     */
    func didFetchProducts()
    
    /**
     Tells the delegate that fetching products failed.
     
     - parameter error: The error for the fetching failure.
     */
    func didFailToFetchProducts(with error: Error)
    
    /**
     Tells the delegate that the purchase transaction got cancelled.
     */
    func didCancelTransaction()
}
