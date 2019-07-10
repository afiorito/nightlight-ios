import UIKit

public class SearchViewController: UIViewController, Themeable {

    private let viewModel: SearchViewModel
    
    init(viewModel: SearchViewModel) {
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
    
    override public var preferredStatusBarStyle: UIStatusBarStyle {
        switch viewModel.theme {
        case .light:
            if #available(iOS 13.0, *) {
                return .darkContent
            } else {
                return .default
            }
        case .dark:
            return .lightContent
        }
    }

}
