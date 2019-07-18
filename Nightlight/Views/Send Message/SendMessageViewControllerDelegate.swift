public protocol SendMessageViewControllerDelegate: class {
    func sendMessageViewControllerDidCancel(_ sendMessageViewController: SendMessageViewController)
    func sendMessageViewController(_ sendMessageViewController: SendMessageViewController, didSend message: MessageViewModel)
}
