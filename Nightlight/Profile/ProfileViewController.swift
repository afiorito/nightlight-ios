import UIKit

/// A view controller for managing the profile.
public class ProfileViewController: UIViewController {
    /// The viewModel for handling state.
    private let viewModel: ProfileViewModel
    
    /// A view for displaying the person header content.
    private let personView = PersonContentView()
    
    /// A background view for extending content view color.
    private let headerBackground = UIView()
    
    /// A view for displaying a bottom header separator.
    public let separatorLineView = UIView()
    
    /// A page controller for handling message view controllers.
    private let pageTabController = PageTabController()
    
    /// An array of view controllers for displaying messages.
    public var messageViewControllers: [UIViewController] {
        get { return pageTabController.viewControllers }
        set { pageTabController.viewControllers = newValue }
    }
    
    public init(viewModel: ProfileViewModel) {
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
        updateView()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        navigationController?.setStyle(.hidden, for: theme)
        super.viewWillAppear(animated)

        viewModel.fetchProfile()
    }
    
    /**
     Update the view with the view model.
     */
    private func updateView() {
        personView.usernameLabel.text = viewModel.username
        personView.dateLabel.text = viewModel.helpingSince
        personView.loveAccolade.actionView.count = viewModel.totalLove
        personView.appreciateAccolade.actionView.count = viewModel.totalAppreciation
    }
    
    private func prepareSubviews() {
        view.addSubviews([headerBackground, separatorLineView, personView])
        add(child: pageTabController)

        additionalSafeAreaInsets.top -= navigationController?.navigationBar.bounds.height ?? 0
        
        NSLayoutConstraint.activate([
            headerBackground.topAnchor.constraint(equalTo: view.topAnchor),
            headerBackground.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerBackground.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerBackground.bottomAnchor.constraint(equalTo: personView.bottomAnchor, constant: 10),
            personView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
            personView.leadingAnchor.constraint(equalTo: view.readableContentGuide.leadingAnchor),
            personView.trailingAnchor.constraint(equalTo: view.readableContentGuide.trailingAnchor),
            separatorLineView.topAnchor.constraint(equalTo: personView.bottomAnchor, constant: 15),
            separatorLineView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            separatorLineView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            separatorLineView.heightAnchor.constraint(equalToConstant: 1 / UIScreen.main.scale),
            pageTabController.view.topAnchor.constraint(equalTo: separatorLineView.bottomAnchor),
            pageTabController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pageTabController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pageTabController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    // MARK: - Gesture Recognizer Handlers
    
    @objc private func didTapSettings() {
        viewModel.showSettings()
    }
    
    deinit {
        removeDidChangeThemeObserver()
    }

}

// MARK: - ProfileViewModel UI Delegate

extension ProfileViewController: ProfileViewModelUIDelegate {
    public func didFetchProfile() {
        updateView()
    }
    
    public func didFailToFetchProfile(with error: PersonError) {}
    public func didBeginFetchingProfile() {}
    public func didEndFetchingProfile() {}
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
        navigationController?.setStyle(.hidden, for: theme)
        headerBackground.backgroundColor = .background(for: theme)
        separatorLineView.backgroundColor = .separator(for: theme)
    }
}
