import Foundation

public protocol Configurable: class {
    associatedtype ViewModel
    associatedtype Delegate: AnyObject

    var delegate: Delegate? { get set }
    
    func configure(with viewModel: ViewModel)
}
