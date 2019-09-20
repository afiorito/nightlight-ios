/// Methods for handling `BuyTokensCoordinator` navigation events.
public protocol BuyTokensCoordinatorNavigationDelegate: class {
    /**
     Tells the delegate to dismiss with a specified outcome.
     
     - parameter outcome: The outcome of the tokens purchase.
     */
    func buyTokensCoordinatorDismiss(with outcome: IAPManager.TransactionOutcome)
}
