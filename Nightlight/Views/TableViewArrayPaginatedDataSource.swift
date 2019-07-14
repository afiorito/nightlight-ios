import UIKit

public class TableViewArrayPaginatedDataSource<Cell: Configurable>: TableViewArrayDataSource<Cell>, UITableViewDataSourcePrefetching {
    
    public var totalCount: Int = 0
    
    public var prefetchCallback: (() -> Void)?
    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return data.count
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! Cell
        
        cell.delegate = cellDelegate
        
        cell.configure(with: data[indexPath.row])
        
        return cell as! UITableViewCell
    }
    
    public func updateData(with newData: [Cell.ViewModel]) -> [IndexPath] {
        self.data.append(contentsOf: newData)

        let startIndex = data.count - newData.count
        let endIndex = startIndex + newData.count
        
        return (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
    }
    
    public func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        if data.count < totalCount && indexPaths.contains(where: isLoadingCell) {
            prefetchCallback?()
        }
    }
    
    private func isLoadingCell(for indexPath: IndexPath) -> Bool {
        return indexPath.row >= data.count - 1
    }
}
