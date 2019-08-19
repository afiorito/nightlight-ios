import Foundation

/// A protocol for configurable views.
public protocol Configurable: class {
    associatedtype ViewModel
    associatedtype Delegate: AnyObject

    /// The delegate for managing UI actions.
    var delegate: Delegate? { get set }
    
    /**
     Configure the view.
     
     - parameter viewModel: a viewModel for handling state.
     */
    func configure(with viewModel: ViewModel)
}
