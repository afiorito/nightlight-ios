import UIKit

public class NLTabBarController: UITabBarController, Themeable {
    public typealias Dependencies = StyleManaging
    
    private let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
        
        addDidChangeThemeObserver()
        
        updateColors(for: dependencies.styleManager.theme)
    }
    
    deinit {
        removeDidChangeThemeObserver()
    }
    
    public func updateColors(for theme: Theme) {
        tabBar.isTranslucent = false
        tabBar.barTintColor = .alternateBackground(for: theme)
        tabBar.clipsToBounds = true
        tabBar.unselectedItemTintColor = .accent(for: theme)
        tabBar.tintColor = .primaryGrayScale(for: theme)
    }
}
