import Foundation

/// Methods for handling UI actions occurring in a sign up view controller.
@objc public protocol SignUpViewControllerDelegate: class {
    /**
     Tells the delegate when sign in action occurs during sign up.
     
     - parameter signUpViewController: a sign up view controller object informing about the sign in action.
     */
    func signUpViewControllerDidTapSignIn(_ signUpViewController: SignUpViewController)
    
    /**
    Tells the delegate when sign up action occurs.
    
    - parameter signUpViewController: a sign up view controller object informing about sign up action.
    */
    func signUpViewControllerDidSignUp(_ signUpViewController: SignUpViewController)
    
    /**
     Tells the delegate when a policy link is selected.
     
     - parameter signUpViewController: a sign up view controller object informing about the policy selection.
     - parameter url: the url of the selected policy.
    */
    func signUpViewController(_ signUpViewController: SignUpViewController, didTapPolicyWith url: URL)
}
