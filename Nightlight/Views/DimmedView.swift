import UIKit

public class DimmedView: UIView {

    enum DimState {
        case max
        case off
        case percent(CGFloat)
    }
    
    // MARK: - Properties

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
    
    var didTap: ((_ recognizer: UIGestureRecognizer) -> Void)?
    
    private lazy var tapGesture: UIGestureRecognizer = {
        UITapGestureRecognizer(target: self, action: #selector(didTapView))
    }()
    
    private let dimAlpha: CGFloat
    
    // MARK: - Initializers
    
    init(dimAlpha: CGFloat = 0.7) {
        self.dimAlpha = dimAlpha
        super.init(frame: .zero)
        alpha = 0.0
        backgroundColor = .black
        addGestureRecognizer(tapGesture)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Event Handlers
    
    @objc private func didTapView() {
        didTap?(tapGesture)
    }
    
}
