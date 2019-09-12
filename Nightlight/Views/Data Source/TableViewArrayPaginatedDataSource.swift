import UIKit

/// A paginated table view datasource for single sectioned, single cell configurable table views.
public class TableViewArrayPaginatedDataSource<Cell: ConfigurableCell & Delegating>: TableViewArrayDataSource<Cell>,
    UITableViewDataSourcePrefetching {
    
    /// The maximum number of cells possible.
    public var totalCount: Int = 0
    
    /// A callback for requesting more data to be displayed.
    public var prefetchCallback: (() -> Void)?
    
    /**
     Update the data source with new data.
     
     - parameter data: the new data to append to the datasource.
     */
    public func updateData(with newData: [Cell.ViewModel]) -> [IndexPath] {
        self.data.append(contentsOf: newData)

        let startIndex = self.data.count - newData.count
        let endIndex = startIndex + newData.count
        
        return (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
    }
    
    public func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        if data.count < totalCount && indexPaths.contains(where: { $0.row >= data.count - 1 }) {
            prefetchCallback?()
        }
    }

}
