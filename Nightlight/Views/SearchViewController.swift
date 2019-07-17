import UIKit

public class SearchViewController: UIViewController {

    private let viewModel: SearchViewModel
    
    let searchController: UISearchController = {
        let searchController = UISearchController()
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.isTranslucent = false
        
        return searchController
    }()
    
    let baseViewController: UIViewController
    let searchViewController: UIViewController
    
    init(viewModel: SearchViewModel, baseViewController: UIViewController, searchViewController: UIViewController) {
        self.viewModel = viewModel
        self.baseViewController = baseViewController
        self.searchViewController = searchViewController
        
        super.init(nibName: nil, bundle: nil)
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        addDidChangeThemeObserver()
        
        navigationItem.titleView = searchController.searchBar
        
        prepareSubviews()
        updateColors(for: theme)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        removeDidChangeThemeObserver()
    }
    
    private func prepareSubviews() {
        add(child: baseViewController)
        
        NSLayoutConstraint.activate([
            baseViewController.view.topAnchor.constraint(equalTo: view.topAnchor),
            baseViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            baseViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            baseViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

}

// MARK: - Themeable

extension SearchViewController: Themeable {
    var theme: Theme {
        return viewModel.theme
    }
    
    public func updateColors(for theme: Theme) {
        view.backgroundColor = .background(for: theme)
        searchController.searchBar.updateColors(for: theme)
    }
}
