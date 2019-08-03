public protocol MessageDetailViewControllerDelegate: class {
    func messageDetailViewController(_ messageDetailViewController: MessageDetailViewController, didUpdate message: MessageViewModel)
    func messageDetailViewController(_ messageDetailViewController: MessageDetailViewController, didDelete message: MessageViewModel)
    func messageDetailViewController(_ messageDetailViewController: MessageDetailViewController, moreContextFor message: MessageViewModel)
    func messageDetailViewController(_ messageDetailViewController: MessageDetailViewController, didAppreciate message: MessageViewModel)
    func messageDetailViewControllerAppreciation(_ messageDetailViewController: MessageDetailViewController, didComplete complete: Bool)
}
