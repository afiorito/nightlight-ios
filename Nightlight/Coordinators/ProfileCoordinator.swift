import UIKit

public class ProfileCoordinator: TabBarCoordinator {
    public typealias Dependencies = StyleManaging

    public weak var parent: Coordinator?
    public var children = [Coordinator]()
    
    private let dependencies: Dependencies

    public lazy var rootViewController: UIViewController = {
        let viewModel = ProfileViewModel(dependencies: dependencies as ProfileViewModel.Dependencies)
        let profileViewController = ProfileViewController(viewModel: viewModel)
        profileViewController.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(named: "tb_profile"), tag: 0)
        
        return profileViewController
    }()
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    public func start() {}

}
