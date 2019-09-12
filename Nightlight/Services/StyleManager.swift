/// a protocol for being able to access StyleManager.
public protocol StyleManaging {
    /// The instance of style manager.
    var styleManager: StyleManager { get }
}

/// Handles application styling.
public class StyleManager {

    public static var `default` = StyleManager()
    
    /// The currently active theme.
    public var theme: Theme = .system {
        didSet {
            guard oldValue != theme else { return }
            
            NLNotification.didChangeTheme.post(userInfo: theme)
        }
    }

}
