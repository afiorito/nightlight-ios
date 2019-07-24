import Foundation

public protocol OptionsTableViewControllerDelegate: class {    
    func optionsTableViewController<E: RawRepresentable & CaseIterable>(_ optionsTableViewController: OptionsTableViewController<E>, didSelect option: E) where E.RawValue == String
}
