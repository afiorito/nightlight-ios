import UIKit

public class ProfileViewController: UIViewController {
    private let viewModel: ProfileViewModel
    
    private let headerBackground = UIView()
    
    private let personView = PersonContentView()
    
    private let pageTabController = PageTabController()
    
    public var messageViewControllers: [UIViewController] {
        get { return pageTabController.viewControllers }
        set { pageTabController.viewControllers = newValue }
    }
    
    init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        addDidChangeThemeObserver()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "nb_settings"), style: .plain, target: self, action: nil)
        
        pageTabController.dataSource = self
        
        prepareSubviews()
        updateColors(for: theme)
        
        viewModel.getProfile { [weak self] result in
            switch result {
            case .success(let viewModel):
                self?.personView.usernameLabel.text = viewModel.username
                self?.personView.dateLabel.text = viewModel.helpingSince
                self?.personView.loveAccolade.actionView.count = viewModel.totalLove
                self?.personView.appreciateAccolade.actionView.count = viewModel.totalAppreciation
            case .failure:
                self?.showToast("Could not connect to Nightlight.", severity: .urgent)
            }
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        removeDidChangeThemeObserver()
    }
    
    private func prepareSubviews() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        
        view.addSubviews([headerBackground, personView])
        add(child: pageTabController)
        
        additionalSafeAreaInsets.top -= navigationController?.navigationBar.bounds.height ?? 0
        
        NSLayoutConstraint.activate([
            headerBackground.topAnchor.constraint(equalTo: view.topAnchor),
            headerBackground.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerBackground.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerBackground.bottomAnchor.constraint(equalTo: personView.bottomAnchor, constant: 10),
            personView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            personView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            personView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            pageTabController.view.topAnchor.constraint(equalTo: headerBackground.bottomAnchor),
            pageTabController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pageTabController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pageTabController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            
        ])
    }
    
    override public var preferredStatusBarStyle: UIStatusBarStyle {
        switch theme {
        case .light:
            if #available(iOS 13.0, *) {
                return .darkContent
            } else {
                return .default
            }
        case .dark:
            return .lightContent
        }
    }

}

// MARK: - PageTabController DataSource

extension ProfileViewController: PageTabControllerDataSource {
    public func pageTabControllerNumberOfTabs(_ pageTabsView: PageTabController) -> Int {
        return 3
    }
    
    public func pageTabController(_ pageTabsView: PageTabController, titleForTabAt index: Int) -> String? {
        return ["Received", "Sent", "Saved"][index]
    }
    
}

// MARK: - Themeable

extension ProfileViewController: Themeable {
    var theme: Theme {
        return viewModel.theme
    }
    
    public func updateColors(for theme: Theme) {
        view.backgroundColor = .background(for: theme)
        headerBackground.backgroundColor = .alternateBackground(for: theme)
        personView.updateColors(for: theme)
    }
}
