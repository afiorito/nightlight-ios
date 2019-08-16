/// Methods for handling UI actions occurring in a send appreciation view controller.
public protocol SendAppreciationViewControllerDelegate: class {
    /**
     Tells the delegate the action button is tapped.
     
     - parameter sendAppreciationViewController: a send appreciation view controller object informing about the action button being tapped.
     */
    func sendAppreciationViewControllerDidTapActionButton(_ sendAppreciationViewController: SendAppreciationViewController)
}
