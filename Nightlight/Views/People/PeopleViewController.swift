import UIKit

public class PeopleViewController: UIViewController {
    
    public var dataSource: TableViewArrayDataSource<MessageTableViewCell>?
    
    public var peopleView: PeopleView {
        return view as! PeopleView
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        addDidChangeThemeObserver()
        
        prepareSubviews()
    }
    
    deinit {
        removeDidChangeThemeObserver()
    }
    
    public override func loadView() {
        view = PeopleView()
    }
    
    private func prepareSubviews() {
        
    }
    
}
