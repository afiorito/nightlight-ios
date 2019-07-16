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
        return ContextOption(title: "Report", image: UIImage(named: "icon_flag"), style: .destructive, handler: handler)
    }
}
