import UIKit

/// A paginated table view datasource for single sectioned, single cell configurable table views.
public class SimpleTableViewPaginatedDataSource<CellType: UITableViewCell>: SimpleTableViewDataSource<CellType>,
    UITableViewDataSourcePrefetching {
    
    /// The total number of rows of the paginated list.
    public var totalCount: Int = 0
    
    /// A callback for requesting more data to be displayed.
    public var prefetchCallback: (() -> Void)?
    
    /**
     Update the data source count.
     
     - parameter count: the new count of rows displayed by the data source.
     */
    public func incrementCount(_ count: Int) -> [IndexPath] {
        self.rowCount += count

        let startIndex = self.rowCount - count
        let endIndex = startIndex + count
        
        return (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
    }
    
    public func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        if rowCount < totalCount && indexPaths.contains(where: { $0.row >= rowCount - 1 }) {
            prefetchCallback?()
        }
    }

}
