public protocol ProfileViewModelUIDelegate: class {
    /**
    Tells the delegate that fetching the profile began.
    */
    func didBeginFetchingProfile()
    
    /**
     Tells the delegate that fetching the profile stopped.
     */
    func didEndFetchingProfile()
    
    /**
     Tells the delegate that fetching the profile failed.
     
     - parameter error: The error for the fetching failure.
     */
    func didFailToFetchProfile(with error: PersonError)
    
    /**
     Tells the delegate that the profile fetched successfully.
     */
    func didFetchProfile()
}
