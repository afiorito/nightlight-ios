import Foundation

/// Methods for handling UI actions occurring in a sign in view controller.
@objc public protocol SignInViewControllerDelegate: class {
    /**
     Tells the delegate when sign up action occurs during sign in.
     
     - parameter signInViewController: a sign in view controller object informing about the sign up action.
     */
    func signInViewControllerDidTapSignUp(_ signInViewController: SignInViewController)
    
    /**
    Tells the delegate when sign in action occurs.
    
    - parameter signInViewController: a sign in view controller object informing about sign in action.
    */
    func signInViewControllerDidSignIn(_ signInViewController: SignInViewController)
}
