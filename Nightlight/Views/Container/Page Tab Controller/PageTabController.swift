import UIKit

public class PageTabController: UIViewController {

    private let pageTabsView = PageTabsView()
    
    private let childrenCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.register(ContainerCollectionViewCell.self, forCellWithReuseIdentifier: ContainerCollectionViewCell.className)
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        
        return collectionView
    }()
    
    public weak var dataSource: PageTabControllerDataSource?
    
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
    
    deinit {
        removeDidChangeThemeObserver()
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // For some reason the collection view initially returns its content size when
        // accessing collectionView.frame until a few passes of viewDidLayoutSubviews
        if childrenCollectionView.visibleCells.first?.frame != childrenCollectionView.frame {
            childrenCollectionView.performBatchUpdates({})
        }
    }
    
    private func prepareSubviews() {
        view.addSubviews([childrenCollectionView, pageTabsView])
        
        NSLayoutConstraint.activate([
            pageTabsView.topAnchor.constraint(equalTo: view.topAnchor),
            pageTabsView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pageTabsView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pageTabsView.heightAnchor.constraint(equalToConstant: 40),
            childrenCollectionView.topAnchor.constraint(equalTo: pageTabsView.bottomAnchor),
            childrenCollectionView.leadingAnchor.constraint(equalTo: pageTabsView.leadingAnchor),
            childrenCollectionView.trailingAnchor.constraint(equalTo: pageTabsView.trailingAnchor),
            childrenCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
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
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return collectionView.frame.size
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let numberOfTabs = dataSource?.pageTabControllerNumberOfTabs(self)
            else { return }
        pageTabsView.offset = scrollView.contentOffset.x / CGFloat(numberOfTabs)
    }
}

// MARK: - PageTabsView DataSource

extension PageTabController: PageTabsViewDataSource {
    public func pageTabsViewNumberOfTabs(_ pageTabsView: PageTabsView) -> Int {
        return dataSource?.pageTabControllerNumberOfTabs(self) ?? 0
    }
    
    public func pageTabsViewController(_ pageTabsView: PageTabsView, titleForTabAt index: Int) -> String? {
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
