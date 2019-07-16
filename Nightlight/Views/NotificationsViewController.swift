import UIKit

public class NotificationsViewController: UIViewController {
    private let viewModel: NotificationsViewModel
    
    init(viewModel: NotificationsViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        addDidChangeThemeObserver()
        
        updateColors(for: theme)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        removeDidChangeThemeObserver()
    }

}

// MARK: - Themeable

extension NotificationsViewController: Themeable {
    var theme: Theme {
        return viewModel.theme
    }

    public func updateColors(for theme: Theme) {
        view.backgroundColor = .background(for: theme)
    }
}
