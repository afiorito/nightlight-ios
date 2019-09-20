/// Methods for updating the user interface from a `SendAppreciationViewModel`.
public protocol SendAppreciationViewModelUIDelegate: class {
    /**
     Tells the delegate to update its view.
     */
    func updateView()
    
    /**
     Tells the delegate that the tokens purchase got cancelled.
     */
    func didCancelPurchase()
    
    /**
     Tells the delegate that the tokens purchase completed successfully.
     */
    func didCompletePurchase()
    
    /**
     Tells the delegate that the tokens purchase failed.
     */
    func didFailPurchase()
}
