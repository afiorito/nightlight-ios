import Foundation

/// Methods for handling UI updates from a messages view model.
public protocol PeopleViewModelUIDelegate: class {
    /**
     Tells the delegate that fetching people began.
     
     - parameter fromStart: A boolean denoting if the data is being fetched from the beginning of a paginated list.
     */
    func didBeginFetchingPeople(fromStart: Bool)
    
    /**
     Tells the delegate that fetching people stopped.
     */
    func didEndFetchingPeople()
    
    /**
     Tells the delegate that fetching people failed.
     
     - parameter error: The error for the fetching failure.
     */
    func didFailToFetchPeople(with error: PersonError)
    
    /**
     Tells the delegate that the people fetched successfully.
     
     - parameter count: The count of the fetched people.
     - parameter fromStart: A boolean denoting if the data is being fetched from the beginning of a paginated list.
     */
    func didFetchPeople(with count: Int, fromStart: Bool)
}
