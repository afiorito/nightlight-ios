/// Methods for updating the user interface from a `SettingsViewModel`.
public protocol SettingsViewModelUIDelegate: class {
    /**
     Tells the delegate that fetching ratings completed successfully.
     */
    func didFetchRatings()
    
    /**
     Tells the delegate that fetching ratings failed.
     
     - parameter error: The erro for the fetching failure.
     */
    func didFailToFetchRatings(with error: Error)
    
    /**
     Tells the delegate that the tokens purchase completed successfully.
     */
    func didCompletePurchase()
    
    /**
     Tells the delegate that the tokens purchase failed.
     */
    func didFailPurchase()
    
    /**
     Tells the delegate to update its tokens count.
     */
    func updateTokens()
    
    /**
     Tells the delegate to update its view.
     */
    func updateView()
}
