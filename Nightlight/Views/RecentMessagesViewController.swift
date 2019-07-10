import UIKit

public class RecentMessagesViewController: UIViewController, Themeable {

    private let viewModel: RecentMessagesViewModel
    
    init(viewModel: RecentMessagesViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        addDidChangeThemeObserver()
        
        updateColors(for: viewModel.theme)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        removeDidChangeThemeObserver()
    }
    
    public func updateColors(for theme: Theme) {
        view.backgroundColor = .background(for: theme)
    }

}
