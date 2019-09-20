import UIKit

/// A table view datasource for single sectioned, single cell configurable table views.
public class SimpleTableViewDataSource<CellType: UITableViewCell>: NSObject, UITableViewDataSource {
    public typealias CellConfigurator = (CellType, IndexPath) -> Void

    /// The number of rows displated by the data source.
    public var rowCount: Int = 0
    
    /// The reuse identifier of a cell.
    internal let reuseIdentifier: String
    
    /// The empty view when the datasource contains no data.
    public var emptyViewDescription: EmptyViewDescription?
    
    /// A callback for configuring a table view cell.
    private let cellConfigurator: CellConfigurator
    
    public var isEmpty: Bool {
        return rowCount <= 0
    }
    
    public init(reuseIdentifier: String, cellConfigurator: @escaping CellConfigurator) {
        self.reuseIdentifier = reuseIdentifier
        self.cellConfigurator = cellConfigurator
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isEmpty, let description = emptyViewDescription {
            tableView.showEmptyView(description: description)
        } else {
            tableView.hideEmptyView()
        }
        
        return rowCount
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! CellType
        cellConfigurator(cell, indexPath)
        return cell
    }
}
