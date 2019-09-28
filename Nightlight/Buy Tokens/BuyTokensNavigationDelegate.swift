/// Methods for handling buy tokens navigation events.
public protocol BuyTokensNavigationDelegate: class {
    /**
     Tells the delegate that the user is no longer buying tokens.
     */
    func didFinishBuyingTokens()
}
