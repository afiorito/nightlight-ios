import UIKit

public class TableViewArrayDataSource<Cell: Configurable>: NSObject, UITableViewDataSource {
    public var data = [Cell.ViewModel]()
    
    internal let reuseIdentifier: String
    
    public weak var cellDelegate: Cell.Delegate?
    
    public init(reuseIdentifier: String) {
        self.reuseIdentifier = reuseIdentifier
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return data.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! Cell
        
        cell.delegate = cellDelegate
        cell.configure(with: data[indexPath.row])
        
        return cell as! UITableViewCell
    }
}
