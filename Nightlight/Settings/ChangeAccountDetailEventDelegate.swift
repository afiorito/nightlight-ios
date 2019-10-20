/// Methods for notifying about an account detail change.
public protocol ChangeAccountDetailEventDelegate: class {
    /**
     Tells the delegate the account detail began changing.
     */
    func didBeginChange()
    
    /**
     Tells the delegate the account detail finished changing.
     */
    func didEndChange()
    
    /**
     Tells the delegate the account detail changed successfully.
     */
    func didChange()
    
    /**
     Tells the delegate the account detail failed to change.
     */
    func didFailChange(with error: PersonError)
    
}
