import Foundation

@objc public protocol OnboardViewControllerDelegate: class {
    func onboardViewControllerDidProceedAsNewUser(_ onboardViewController: OnboardViewController)
    func onboardViewControllerDidProceedAsExistingUser(_ onboardViewController: OnboardViewController)
}
