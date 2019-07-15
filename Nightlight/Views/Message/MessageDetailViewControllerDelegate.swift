public protocol MessageDetailViewControllerDelegate: class {
    func messageDetailViewController(_ messageDetailViewController: MessageDetailViewController, didUpdate message: MessageViewModel)
}
