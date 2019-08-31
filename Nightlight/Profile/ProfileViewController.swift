import UIKit

/// A view controller for managing the profile.
public class ProfileViewController: UIViewController {
    /// The viewModel for handling state.
    private let viewModel: ProfileViewModel
    
    /// A view for displaying the person header content.
    private let personView = PersonContentView()
    
    /// A background view for extending content view color.
    private let headerBackground = UIView()
    
    /// A page controller for handling message view controllers.
    private let pageTabController = PageTabController()
    
    /// The delegate for managing UI actions.
    public weak var delegate: ProfileViewControllerDelegate?
    
    /// An array of view controllers for displaying messages.
    public var messageViewControllers: [UIViewController] {
        get { return pageTabController.viewControllers }
        set { pageTabController.viewControllers = newValue }
    }
    
    init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Controller Lifecyle
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        addDidChangeThemeObserver()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage.icon.settings, style: .plain, target: self,
                                                            action: #selector(didTapSettings))
        
        pageTabController.dataSource = self
        
        prepareSubviews()
        updateColors(for: theme)
        
        self.personView.usernameLabel.text = viewModel.username
        self.personView.dateLabel.text = viewModel.dateSince
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        navigationController?.setStyle(.hidden, for: theme)
        super.viewWillAppear(animated)
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        viewModel.getProfile { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let viewModel):
                self.personView.usernameLabel.text = viewModel.username
                self.personView.dateLabel.text = viewModel.helpingSince
                self.personView.loveAccolade.actionView.count = viewModel.totalLove
                self.personView.appreciateAccolade.actionView.count = viewModel.totalAppreciation
            case .failure: break
            }
        }
    }
    
    private func prepareSubviews() {
        view.addSubviews([headerBackground, personView])
        add(child: pageTabController)

        additionalSafeAreaInsets.top -= navigationController?.navigationBar.bounds.height ?? 0
        
        NSLayoutConstraint.activate([
            headerBackground.topAnchor.constraint(equalTo: view.topAnchor),
            headerBackground.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerBackground.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerBackground.bottomAnchor.constraint(equalTo: personView.bottomAnchor, constant: 10),
            personView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
            personView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            personView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            pageTabController.view.topAnchor.constraint(equalTo: headerBackground.bottomAnchor),
            pageTabController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pageTabController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pageTabController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    // MARK: - Gesture Recognizer Handlers
    
    @objc private func didTapSettings() {
        delegate?.profileViewControllerDidTapSettings(self)
    }
    
    deinit {
        removeDidChangeThemeObserver()
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
        personView.updateColors(for: theme)
        headerBackground.backgroundColor = .background(for: theme)
    }
}
