import Foundation

/// Methods for handling UI actions occurring in a onboard view controller.
@objc public protocol OnboardViewControllerDelegate: class {
    /**
     Tells the delegate that user is proceeding as a new user.
     
     - parameter onboardViewController: an onboard view controller object informing about the choice to proceed as a new user.
     */
    func onboardViewControllerDidProceedAsNewUser(_ onboardViewController: OnboardViewController)
    
    /**
     Tells the delegate that user is proceeding as an existing user.
     
     - parameter onboardViewController: an onboard view controller object informing about the choice to proceed as an existing user.
     */
    func onboardViewControllerDidProceedAsExistingUser(_ onboardViewController: OnboardViewController)
}
