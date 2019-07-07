import Foundation

@objc public protocol SignUpViewControllerDelegate: class {
    func signUpViewControllerDidTapSignIn(_ signUpViewController: SignUpViewController)
}
