import UIKit

/// A view for displaying tabs.
public class PageTabsView: UIView {
    /// The object that acts as the data source for the tabs view.
    public weak var dataSource: PageTabsViewDataSource?
    
    /// The object that acts as the delegate of the tabs view.
    public weak var delegate: PageTabsViewDelegate?
    
    /// A collection view for displaying tabs.
    private let collectionView: UICollectionView = {
        let layout = TabFlowLayout()
        layout.minimumLineSpacing = 1
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(TabCollectionViewCell.self, forCellWithReuseIdentifier: TabCollectionViewCell.className)
        collectionView.bounces = false
        
        return collectionView
    }()
    
    private let tabIndicatorView = UIView()
    
    public var offset: CGFloat {
        get { return tabIndicatorLeadingAnchor?.constant ?? 0 }
        set { tabIndicatorLeadingAnchor?.constant = newValue }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        updateColors(for: theme)
        prepareSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var tabIndicatorLeadingAnchor: NSLayoutConstraint?
    private var tabIndicatorWidthAnchor: NSLayoutConstraint?
    
    private func prepareSubviews() {
        addSubviews([collectionView, tabIndicatorView])
    
        tabIndicatorLeadingAnchor = tabIndicatorView.leadingAnchor.constraint(equalTo: leadingAnchor)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            tabIndicatorLeadingAnchor!,
            tabIndicatorView.heightAnchor.constraint(equalToConstant: 1),
            tabIndicatorView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

}

// MARK: - UICollectionView DataSource

extension PageTabsView: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let numberOfTabs = dataSource?.pageTabsViewNumberOfTabs(self), numberOfTabs > 0 else {
            return 0
        }
        
        tabIndicatorWidthAnchor = tabIndicatorView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1.0 / CGFloat(numberOfTabs))
        tabIndicatorWidthAnchor?.isActive = true
        return dataSource?.pageTabsViewNumberOfTabs(self) ?? 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TabCollectionViewCell.className, for: indexPath) as! TabCollectionViewCell
        
        cell.title = dataSource?.pageTabsView(self, titleForTabAt: indexPath.item)
        cell.updateColors(for: theme)
        
        return cell
    }
    
}

// MARK: - UICollectionView Delegate

extension PageTabsView: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.pageTabsView(self, didSelectTabAt: indexPath.item)
    }
}

// MARK: - UICollectionView Flow Layout Delegate

extension PageTabsView: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let numberOfTabs = dataSource?.pageTabsViewNumberOfTabs(self), let layout = collectionViewLayout as? TabFlowLayout
            else { return .zero }

        let numTabs = CGFloat(numberOfTabs)
        let width = (self.frame.width - (numTabs - 1) * layout.minimumLineSpacing) / numTabs
        
        return CGSize(width: width, height: self.frame.height)
    }
}

// MARK: - Themeable

extension PageTabsView: Themeable {
    func updateColors(for theme: Theme) {
        backgroundColor = .background(for: theme)
        collectionView.backgroundColor = .background(for: theme)
        tabIndicatorView.backgroundColor = .accent(for: theme)
        collectionView.reloadData()
    }
}
