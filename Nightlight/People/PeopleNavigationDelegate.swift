/// Methods for handling people navigation events.
public protocol PeopleNavigationDelegate: class {
    /**
     Tells the delegate that the user stopped viewing people.

     */
    func didFinishViewingPeople()
}
