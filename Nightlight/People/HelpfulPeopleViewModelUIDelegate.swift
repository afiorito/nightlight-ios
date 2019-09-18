import Foundation

/// Methods for handling UI updates from a messages view model.
public protocol HelpfulPeopleViewModelUIDelegate: class {
    /**
     Tells the delegate that fetching people began.
     */
    func didBeginFetchingHelpfulPeople()
    
    /**
     Tells the delegate that fetching people stopped.
     */
    func didEndFetchingHelpfulPeople()
    
    /**
     Tells the delegate that fetching people failed.
     
     - parameter error: The error for the fetching failure.
     */
     func didFailToFetchHelpfulPeople(with error: PersonError)
    
    /**
     Tells the delegate that the people fetched successfully.
     
     - parameter count: The count of the fetched people.
     */
    func didFetchHelpfulPeople(with count: Int)
}
