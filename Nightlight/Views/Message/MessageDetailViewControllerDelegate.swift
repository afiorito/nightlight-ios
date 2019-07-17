public protocol MessageDetailViewControllerDelegate: class {
    func messageDetailViewController(_ messageDetailViewController: MessageDetailViewController, didUpdate message: MessageViewModel)
    func messageDetailViewController(_ messageDetailViewController: MessageDetailViewController, moreContextFor message: MessageViewModel)
}
