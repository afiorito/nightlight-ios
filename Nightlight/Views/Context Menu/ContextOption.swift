import UIKit

public struct ContextOption {
    typealias ContextOptionHandler = ((ContextOption) -> Void)
    let title: String
    let image: UIImage?
    let style: ContextOptionStyle
    let handler: ContextOptionHandler?
}

extension ContextOption {
    static func reportOption(_ handler: ContextOptionHandler? = nil) -> ContextOption {
        return ContextOption(title: "Report", image: UIImage(named: "icon_flag"), style: .default, handler: handler)
    }
    
    static func deleteOption(_ handler: ContextOptionHandler? = nil) -> ContextOption {
            return ContextOption(title: "Delete", image: UIImage(named: "icon_trash"), style: .destructive, handler: handler)
        }
}
