public protocol SendAppreciationViewControllerDelegate: class {
    func sendAppreciationViewControllerDidAppreciate(_ buyAppreciationViewController: SendAppreciationViewController)
    func sendAppreciationViewControllerDidFailAppreciate(_ buyAppreciationViewController: SendAppreciationViewController)
    func sendAppreciationViewControllerDidTapActionButton(_ sendAppreciationViewController: SendAppreciationViewController)
}
