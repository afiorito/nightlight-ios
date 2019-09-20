import Foundation

/// Methods for handling authentication navigation events.
public protocol AuthNavigationDelegate: class {
    /**
     Tells the delegate the user authenticated successfully.
     */
    func didAuthenticate()
    
    /**
     Tells the delegate to show a policy with a specified url.
     
     - parameter url: The url of the policy.
     */
    func showPolicy(with url: URL)
    
    /**
     Tells the delegate to go to the sign up view.
     */
    func goToSignUp()
    
    /**
     Tells the delegate to go to the sign in view.
     */
    func goToSignIn()
}
