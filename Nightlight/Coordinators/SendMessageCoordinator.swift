import UIKit

public class SendMessageCoordinator: TabBarCoordinator {
    public typealias Dependencies = StyleManaging
    public weak var parent: Coordinator?
    public var children = [Coordinator]()
    
    public lazy var rootViewController: UIViewController = {
        let viewModel = SendMessageViewModel(dependencies: dependencies as SendMessageViewModel.Dependencies)
        let sendMessageViewController = SendMessageViewController(viewModel: viewModel)
        sendMessageViewController.tabBarItem = UITabBarItem(title: "Post", image: UIImage(named: "tb_post"), tag: 0)
        
        return sendMessageViewController
    }()
    
    private let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    public func start() {}
    
}
