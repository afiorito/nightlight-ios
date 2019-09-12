import UIKit

/// A table view datasource for single sectioned, single cell configurable table views.
public class TableViewArrayDataSource<Cell: ConfigurableCell & Delegating>: NSObject, UITableViewDataSource {
    /// The content of the datasource.
    public var data = [Cell.ViewModel]()
    
    /// The reuse identifier of a cell.
    internal let reuseIdentifier: String
    
    /// The delegate of a cell.
    public weak var cellDelegate: Cell.Delegate?
    
    /// The empty view when the datasource contains no data.
    public var emptyViewDescription: EmptyViewDescription?
    
    public init(reuseIdentifier: String) {
        self.reuseIdentifier = reuseIdentifier
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let description = emptyViewDescription, data.isEmpty {
            tableView.showEmptyView(description: description)
        } else {
            tableView.hideEmptyView()
        }
        
        return data.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! Cell
        
        cell.delegate = cellDelegate
        cell.configure(with: data[indexPath.row])
        
        return cell
    }
}
