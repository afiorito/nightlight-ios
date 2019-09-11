import UIKit

/// A container view controller for swiping between view controller tabs.
public class PageTabController: UIViewController {

    /// A view for displaying the current tab.
    private let pageTabsView = PageTabsView()
    
    /// A collection view for swiping between view controllers.
    private let childrenCollectionView: UICollectionView = {
        let flowLayout = ContainerFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.register(ContainerCollectionViewCell.self, forCellWithReuseIdentifier: ContainerCollectionViewCell.className)
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        
        return collectionView
    }()
    
    /// The object that acts as the data source of the view controller pages.
    public weak var dataSource: PageTabControllerDataSource?
    
    public var activeTab: Int {
        return Int(childrenCollectionView.contentOffset.x / childrenCollectionView.bounds.width)
    }
    
    /// The last active tab before device orientation change.
    private var lastTab: CGFloat = 0
    
    /// An array of view controllers for the pages.
    public var viewControllers = [UIViewController]() {
        didSet {
            childrenCollectionView.performBatchUpdates({})
        }
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()

        addDidChangeThemeObserver()
        
        pageTabsView.dataSource = self
        pageTabsView.delegate = self
        childrenCollectionView.delegate = self
        childrenCollectionView.dataSource = self
        
        prepareSubviews()
        updateColors(for: theme)
    }

    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        self.childrenCollectionView.contentOffset.x = lastTab * self.childrenCollectionView.bounds.width
    }
    
    public override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        lastTab = childrenCollectionView.contentOffset.x / childrenCollectionView.bounds.width
        
        coordinator.animate(alongsideTransition: { _ in
            self.pageTabsView.offset = self.scrollPercentage(for: self.childrenCollectionView)
            self.pageTabsView.collectionView.collectionViewLayout.invalidateLayout()
            self.childrenCollectionView.contentOffset.x = self.lastTab * self.childrenCollectionView.bounds.width
        })
    }
    
    private func scrollPercentage(for scrollView: UIScrollView) -> CGFloat {
        guard let numberOfTabs = dataSource?.pageTabControllerNumberOfTabs(self), !scrollView.frame.equalTo(.zero)
            else { return 0.0 }
        
        return scrollView.contentOffset.x / (scrollView.frame.width * CGFloat(numberOfTabs))
    }
    
    private func prepareSubviews() {
        view.addSubviews([pageTabsView, childrenCollectionView])
        
        let layoutGuide: UILayoutGuide
        
        switch UIDevice.current.userInterfaceIdiom {
        case .pad: layoutGuide = view.readableContentGuide
        default: layoutGuide = view.safeAreaLayoutGuide
        }
        
        NSLayoutConstraint.activate([
            pageTabsView.topAnchor.constraint(equalTo: view.topAnchor),
            pageTabsView.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor),
            pageTabsView.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor),
            pageTabsView.heightAnchor.constraint(equalToConstant: 40),
            childrenCollectionView.topAnchor.constraint(equalTo: pageTabsView.bottomAnchor),
            childrenCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            childrenCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            childrenCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    deinit {
        removeDidChangeThemeObserver()
    }
}

// MARK: - UICollectionView DataSource

extension PageTabController: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewControllers.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard (dataSource?.pageTabControllerNumberOfTabs(self) ?? 0) == viewControllers.count
            else {
                preconditionFailure("The number of view controllers should equal the number of tabs")
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContainerCollectionViewCell.className,
                                                      for: indexPath) as! ContainerCollectionViewCell
        
        let viewController = viewControllers[indexPath.item]
        
        if viewController.parent == nil {
            addChild(viewController)
            viewController.didMove(toParent: self)
        }
        
        cell.childView = viewController.view
        
        return cell
    }
    
}

// MARK: - UICollectionView Delegate

extension PageTabController: UICollectionViewDelegateFlowLayout {    
    public func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        pageTabsView.offset = scrollPercentage(for: scrollView)
    }
    
    public func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return false
    }
}

// MARK: - PageTabsView DataSource

extension PageTabController: PageTabsViewDataSource {
    public func pageTabsViewNumberOfTabs(_ pageTabsView: PageTabsView) -> Int {
        return dataSource?.pageTabControllerNumberOfTabs(self) ?? 0
    }
    
    public func pageTabsView(_ pageTabsView: PageTabsView, titleForTabAt index: Int) -> String? {
        return dataSource?.pageTabController(self, titleForTabAt: index)
    }
    
}

// MARK: - PageTabsView Delegate

extension PageTabController: PageTabsViewDelegate {
    public func pageTabsView(_ pageTabsView: PageTabsView, didSelectTabAt index: Int) {
        childrenCollectionView.selectItem(at: IndexPath(item: index, section: 0), animated: true, scrollPosition: .centeredHorizontally)
    }
}

// MARK: - Themeable

extension PageTabController: Themeable {
    func updateColors(for theme: Theme) {
        pageTabsView.updateColors(for: theme)
        childrenCollectionView.backgroundColor = .background(for: theme)
    }
}
