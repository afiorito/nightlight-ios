import Foundation

public protocol WebContentViewControllerDelegate: class {
    func webContentViewController(_ webContentViewController: WebContentViewController, didNavigateTo url: URL)
}
