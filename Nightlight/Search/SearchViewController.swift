import UIKit

/// A view controller for managing search.
public class SearchViewController: UIViewController {
    public typealias SearchResultsController = UIViewController & Searchable
    
    /// The active search task. Used to throttle searching.
    private var searchTask: DispatchWorkItem?
    
    /// A view controller to display when user is not searching.
    private let baseViewController: UIViewController
    
    /// A view controller to display when user is searching.
    private let searchResultsController: SearchResultsController
    
    /// A search controller for the search bar.
    lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: searchResultsController)
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.isTranslucent = false
        searchController.searchBar.autocapitalizationType = .none
        searchController.searchResultsUpdater = self
        
        return searchController
    }()

    init(baseViewController: UIViewController, searchResultsController: SearchResultsController) {
        self.baseViewController = baseViewController
        self.searchResultsController = searchResultsController
        
        super.init(nibName: nil, bundle: nil)
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        addDidChangeThemeObserver()
        
        navigationItem.titleView = searchController.searchBar
        definesPresentationContext = true
        
        prepareSubviews()
        updateColors(for: theme)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
    
    deinit {
        removeDidChangeThemeObserver()
    }

}

// MARK: - UISearchController Delegate

extension SearchViewController: UISearchResultsUpdating {
    public func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else {
            return
        }
        
        let strippedString = text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
        self.searchTask?.cancel()
        
        let task = DispatchWorkItem { [weak self] in
            self?.searchResultsController.updateQuery(text: strippedString.lowercased())
        }
        
        self.searchTask = task
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.35, execute: task)
    }
    
}

// MARK: - Themeable

extension SearchViewController: Themeable {
    public func updateColors(for theme: Theme) {
        view.backgroundColor = .background(for: theme)
        searchController.searchBar.updateColors(for: theme)
    }
}
