import UIKit

/// An easily dimmable view.
public class DimmedView: UIView {
    /// A constant for denoting the current state of the dim view.
    enum DimState {
        case max
        case off
        case percent(CGFloat)
    }
    
    // MARK: - Properties

    /// The current state of the view.
    var dimState: DimState = .off {
        didSet {
            switch dimState {
            case .max:
                alpha = dimAlpha
            case .off:
                alpha = 0.0
            case .percent(let percentage):
                let val = max(0.0, min(1.0, percentage))
                alpha = dimAlpha * val
            }
        }
    }
    
    /// A callback for when the button is tapped.
    var didTap: (() -> Void)?
    
    /// The alpha of the view.
    private let dimAlpha: CGFloat
    
    // MARK: - Initializers
    
    init(dimAlpha: CGFloat = 0.7) {
        self.dimAlpha = dimAlpha
        super.init(frame: .zero)
        alpha = 0.0
        backgroundColor = .black
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapView)))
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Event Handlers
    
    @objc private func didTapView() {
        didTap?()
    }
    
}
