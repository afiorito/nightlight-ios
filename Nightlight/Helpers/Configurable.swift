import UIKit

/// A protocol for configurable views.
public protocol Configurable: class {
    associatedtype ViewModel
    
    /**
     Configure the view.
     
     - parameter viewModel: a viewModel for handling state.
     */
    func configure(with viewModel: ViewModel)
}

public typealias ConfigurableCell = UITableViewCell & Configurable
