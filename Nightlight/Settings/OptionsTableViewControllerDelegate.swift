import Foundation

/// Methods for handling UI actions occurring in a options table view controller.
public protocol OptionsTableViewControllerDelegate: class {
    /**
     Tells the delegate that an option is selected.
     
     - parameter optionsTableViewController: an options table view controller object informing about the option selection.
     - parameter option: the option being selected.
     */
    func optionsTableViewController<E: RawRepresentable & CaseIterable>(_ optionsTableViewController: OptionsTableViewController<E>, didSelect option: E) where E.RawValue == String
}
