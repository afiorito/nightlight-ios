import Foundation

/// Methods for receiving information about the state of the modal transition.
@objc public protocol ModalPresentationControllerDelegate: class {
    /**
     The modal presentation will begin.
     
     - parameter modalPresentationController: a modal presentation controller object informing about the beginning of the presentation.
     */
    @objc optional func modalPresentationControllerWillPresent(_ modalPresentationController: ModalPresentationController)
    
    /**
     The modal finished presenting.
     
     - parameter modalPresentationController: a modal presentation controller object informing about the presentation.
     - parameter completed: a boolean indicating the completion of the transition.
     */
    @objc optional func modalPresentationController(_ modalPresentationController: ModalPresentationController, didPresent completed: Bool)
    
    /**
     The modal will dismiss.
     
     - parameter modalPresentationController: a modal presentation controller object informing about beginning of the dismissal.
     */
    @objc optional func modalPresentationControllerWillDimiss(_ modalPresentationController: ModalPresentationController)
    
    /**
     The modal finished dismissing.
     
     - parameter modalPresentationController: a modal presentation controller object informing about the dismissal.
     - parameter completed: a boolean indicating the completion of the transition.
     */
    @objc optional func modalPresentationController(_ modalPresentationController: ModalPresentationController, didDismiss completed: Bool)
}
