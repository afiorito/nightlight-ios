import UIKit

public class OnboardViewController: UIViewController {
    public var pages = [UIViewController]()
    
    private let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
    
    private lazy var pageControl: PageControl = {
        let pageControl = PageControl()
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = 0
        
        return pageControl
    }()
    
    private let buttonContainer: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .center
        stackView.axis = .vertical
        stackView.spacing = 20
        return stackView
    }()
    
    private let getStartedButton: ContainedButton = {
        let button = ContainedButton()
        button.setTitle("Get Started", for: .normal)
        button.backgroundColor = .brand
        return button
    }()
    
    private let signInButton: TextButton = {
        let button = TextButton()
        button.setTitle("Sign In", for: .normal)
        
        return button
    }()
    
    public weak var delegate: OnboardViewControllerDelegate?
    
    deinit {
        removeDidChangeThemeObserver()
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        addDidChangeThemeObserver()
        
        for onboardData in Strings.onboard {
            let page = OnboardPageViewController()
            page.titleText = onboardData.title
            page.subtitleText = onboardData.subtitle
            page.image = UIImage(named: onboardData.image)
            pages.append(page)
        }
        
        pageViewController.setViewControllers([pages[0]], direction: .forward, animated: false)
        pageViewController.dataSource = self
        pageViewController.delegate = self
        
        getStartedButton.addTarget(self, action: #selector(getStartedTapped), for: .touchUpInside)
        signInButton.addTarget(self, action: #selector(signInTapped), for: .touchUpInside)
        
        prepareSubviews()
    }
    
    @objc private func getStartedTapped() {
        delegate?.onboardViewControllerDidProceedAsNewUser(self)
    }
    
    @objc private func signInTapped() {
        delegate?.onboardViewControllerDidProceedAsExistingUser(self)
    }

    private func prepareSubviews() {
        add(child: pageViewController)
        
        buttonContainer.addArrangedSubviews([getStartedButton, signInButton])
        view.addSubviews([pageControl, buttonContainer])
        
        let bottomThird = UILayoutGuide()
        view.addLayoutGuide(bottomThird)
        
        NSLayoutConstraint.activate([
            pageControl.topAnchor.constraint(equalTo: pageViewController.view.bottomAnchor, constant: -10),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pageViewController.view.topAnchor.constraint(equalTo: view.topAnchor),
            pageViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pageViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pageViewController.view.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 2.0 / 3.0),
            bottomThird.topAnchor.constraint(equalTo: pageViewController.view.bottomAnchor),
            bottomThird.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            buttonContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            buttonContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            buttonContainer.centerYAnchor.constraint(equalTo: bottomThird.centerYAnchor)
        ])
        
        updateColors(for: theme)
    }
    
    private func page(at index: Int, direction: UIPageViewController.NavigationDirection) -> Int? {
        let newIndex = direction == .forward ? index + 1 : index - 1
        
        if newIndex < 0 || newIndex > pages.count - 1 {
            return nil
        }
        
        return newIndex
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

// MARK: - UIPageViewController Datasource

extension OnboardViewController: UIPageViewControllerDataSource {
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = pages.firstIndex(of: viewController),
            let page = page(at: index, direction: .reverse) else {
            return nil
        }
        
        return pages[page]
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = pages.firstIndex(of: viewController),
            let page = page(at: index, direction: .forward) else {
            return nil
        }
        
        return pages[page]
    }
    
}

// MARK: - UIPageViewController Delegate

extension OnboardViewController: UIPageViewControllerDelegate {
    public func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard completed,
            let currentPageViewController = pageViewController.viewControllers?.first,
            let index = pages.firstIndex(of: currentPageViewController)
        else {
            return
        }
        
        self.pageControl.currentPage = index

    }
}

// MARK: - Themeable

extension OnboardViewController: Themeable {
    public func updateColors(for theme: Theme) {
        view.backgroundColor = .background(for: theme)
        signInButton.updateColors(for: theme)
        pageControl.updateColors(for: theme)
        
    }
}
