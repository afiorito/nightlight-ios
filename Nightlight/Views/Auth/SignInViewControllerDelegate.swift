import Foundation

@objc public protocol SignInViewControllerDelegate: class {
    func signInViewControllerDidTapSignUp(_ signInViewController: SignInViewController)
}
