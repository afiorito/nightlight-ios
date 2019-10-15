import Foundation

/// A view model for handling setting options.
public class OptionsViewModel<E: RawRepresentable & CaseIterable> {
    
    /// The delegate object that handles navigation events.
    public weak var navigationDelegate: SettingsNavigationDelegate?
    
    /// The active option.
    private(set) var currentOption: E
    
    /// The number of possible options.
    public var optionCount: Int {
        return E.allCases.count
    }
    
    /// The title of the option selection.
    public var title: String {
        "\(E.self)".splitBefore(separator: { $0.isUppercase }).map { String($0) }.joined(separator: " ")
    }
    
    init(currentOption: E) {
        self.currentOption = currentOption
    }
    
    /**
     Returns an option at a specified indexPath.
     
     - parameter indexPath: The index path for the message.
     */
    public func option(at indexPath: IndexPath) -> E {
        E.allCases[E.allCases.index(E.allCases.startIndex, offsetBy: indexPath.row)]
    }
    
    /**
     Select an option at a specified indexPath.
     
     - parameter indexPath: The index path of the message.
     */
    public func selectOption(at indexPath: IndexPath) {
        let option = E.allCases[E.allCases.index(E.allCases.startIndex, offsetBy: indexPath.row)]

        self.currentOption = option
        
        if let theme = option as? Theme {
            navigationDelegate?.didChangeTheme(to: theme)
        } else if let messageDefault = option as? MessageDefault {
            navigationDelegate?.didChangeMessageDefault(to: messageDefault)
        }
    }
}
