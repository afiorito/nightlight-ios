import Foundation

@objc public protocol ModalPresentationControllerDelegate: class {
    @objc optional func modalPresentationControllerWillPresent(_ modalPresentationController: ModalPresentationController)
    @objc optional func modalPresentationController(_ modalPresentationController: ModalPresentationController, didPresent completed: Bool)
    @objc optional func modalPresentationControllerWillDimiss(_ modalPresentationController: ModalPresentationController)
    @objc optional func modalPresentationController(_ modalPresentationController: ModalPresentationController, didDismiss completed: Bool)
}
