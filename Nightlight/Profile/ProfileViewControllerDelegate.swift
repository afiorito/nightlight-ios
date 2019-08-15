/// Methods for handling UI actions occurring in a profile view controller.
public protocol ProfileViewControllerDelegate: class {
    /**
     Tells the delegate that settings were selected.
     
     - parameter profileViewController: a profile view controller object informing about the settings selection.
     */
    func profileViewControllerDidTapSettings(_ profileViewController: ProfileViewController)
}
