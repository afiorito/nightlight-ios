import UIKit

/// A representation of a context option.
public struct ContextOption {
    typealias ContextOptionHandler = ((ContextOption) -> Void)
    let title: String
    let image: UIImage?
    let style: ContextOptionStyle
    let handler: ContextOptionHandler?
}

extension ContextOption {
    static func reportOption(_ handler: ContextOptionHandler? = nil) -> ContextOption {
        return ContextOption(title: Strings.report, image: UIImage.icon.flag, style: .default, handler: handler)
    }
    
    static func deleteOption(_ handler: ContextOptionHandler? = nil) -> ContextOption {
        return ContextOption(title: Strings.delete, image: UIImage.icon.trash, style: .destructive, handler: handler)
    }
}
