import UIKit
import WebKit

/// A view controller for displaying nightlight page content.
public class WebContentViewController: UIViewController {
    /// The url of the page to display.
    private let url: URL
    
    /// The user content controller to associate with the web view.
    private var userContentController = WKUserContentController()
    
    /// The delegate for managing UI actions.
    public weak var delegate: WebContentViewControllerDelegate?
    
    /// A web view for displaying web content.
    private lazy var webView: WKWebView = {
        let configuration = WKWebViewConfiguration()
        configuration.userContentController = userContentController
        
        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        webView.isOpaque = false
        
        return webView
    }()
    
    /// An activity indicator while the web content is loading.
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.hidesWhenStopped = true
        indicator.style = .gray
        
        return indicator
    }()
    
    init(url: URL) {
        self.url = url
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()

        webView.scrollView.delegate = self

        title = ExternalPage(rawValue: url.absoluteString)?.title
        if navigationItem.leftBarButtonItem == nil {
            navigationItem.leftBarButtonItem = UIBarButtonItem.cancel(target: self, action: #selector(cancel))
        }
        
        prepareSubviews()
        updateColors(for: theme)
        loadContent(at: url, selector: "main.container")
    }

    /**
     Load the web page content.
     
     - parameter url: the url of the web page.
     - parameter selector: the selector for the element of the webpage to select.
     */
    private func loadContent(at url: URL, selector: String? = nil) {
        userContentController.removeAllUserScripts()
        if let selector = selector {
            let userScript = WKUserScript(source: queryScript(using: selector), injectionTime: .atDocumentEnd, forMainFrameOnly: true)
            userContentController.addUserScript(userScript)
        }
        
        webView.load(URLRequest(url: url))
    }
    
    /**
     Executes JavaScript to select an element using the given selector and style the page.
     
     - parameter selector: the selector of an element on the page.
     */
    private func queryScript(using selector: String) -> String {
        return  """
                document.body.style.backgroundColor = "\(UIColor.background(for: theme).hexString)";
                document.querySelectorAll('h2').forEach(h => h.style.color = "\(UIColor.primaryText(for: theme).hexString)");
                document.querySelectorAll('h3').forEach(h => h.style.color = "\(UIColor.primaryText(for: theme).hexString)");
                document.querySelectorAll('h3').forEach(h => h.style.color = "\(UIColor.primaryText(for: theme).hexString)");
                document.body.style.color = "\(UIColor.primaryText(for: theme).hexString)";
                let el = document.querySelector('\(selector)');
                let title = document.querySelector('h1');
                title.parentNode.removeChild(title);
                document.body.innerHTML = el.innerHTML;
                """
    }
    
    private func prepareSubviews() {
        view.addSubviews([webView, activityIndicator])
        
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    @objc public func cancel() {
        dismiss(animated: true)
    }
    
}

// MARK: - WKWebView UI Delegate

extension WebContentViewController: WKNavigationDelegate, WKUIDelegate {
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activityIndicator.stopAnimating()
    }

    public func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        activityIndicator.startAnimating()
    }
    
    public func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        activityIndicator.stopAnimating()
        
        showToast(Strings.error.somethingWrong, severity: .urgent)
    }
    
    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if navigationAction.navigationType == .linkActivated {
            if let url = navigationAction.request.url {
                delegate?.webContentViewController(self, didNavigateTo: url)
            }
            
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }
}

// MARK: - UIScrollView Delegate

extension WebContentViewController: UIScrollViewDelegate {
    public func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        // disable zooming in webview scrollview
        scrollView.pinchGestureRecognizer?.isEnabled = false
    }
}

// MARK: - Themeable

extension WebContentViewController: Themeable {
    func updateColors(for theme: Theme) {
        view.backgroundColor = .background(for: theme)
        webView.backgroundColor = .background(for: theme)
    }
}
