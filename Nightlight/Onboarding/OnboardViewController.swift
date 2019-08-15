import UIKit

/// A view controller for managing onboarding.
public class OnboardViewController: UIViewController {
    
    /// The delegate for managing UI actions.
    public weak var delegate: OnboardViewControllerDelegate?
    
    /// The onboarding view controller pages.
    public var pages = [UIViewController]()
    
    /// A view controller for managing the onboarding pages.
    private let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
    
    /// The page indicator for the onboarding pages.
    private lazy var pageControl: PageControl = {
        let pageControl = PageControl()
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = 0
        
        return pageControl
    }()
    
    /// A button for a getting started action.
    private let getStartedButton: ContainedButton = {
        let button = ContainedButton()
        button.setTitle(Strings.onboard.getStarted, for: .normal)
        button.backgroundColor = .brand
        return button
    }()
    
    /// A button for a sign in action.
    private let signInButton: TextButton = {
        let button = TextButton()
        button.setTitle(Strings.onboard.signIn, for: .normal)
        
        return button
    }()
    
    private let buttonContainer: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .center
        stackView.axis = .vertical
        stackView.spacing = 20
        return stackView
    }()
    
    deinit {
        removeDidChangeThemeObserver()
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        addDidChangeThemeObserver()
        
        for onboardData in Strings.onboard.pages {
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
    
    // MARK: - Gesture Recognizer Handlers
    
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
    
    /**
     Computes the next pages giving the current page index.
     
     - parameter index: the index of the current page.
     - parameter direction: the scrolling direction of the page view controller.
     */
    private func nextPage(for index: Int, direction: UIPageViewController.NavigationDirection) -> Int? {
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
            let page = nextPage(for: index, direction: .reverse) else {
            return nil
        }
        
        return pages[page]
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = pages.firstIndex(of: viewController),
            let page = nextPage(for: index, direction: .forward) else {
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
