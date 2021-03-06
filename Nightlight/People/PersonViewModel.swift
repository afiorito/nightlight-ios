import Foundation

/// A view model for handling a person.
public class PersonViewModel {
    /// A formatter for the creation date of a user.
    static var formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM YYYY"
        
        return formatter
    }()
    
    /// The backing user model.
    private let user: User
    
    public init(user: User) {
        self.user = user
    }
    
    /// The username of a person.
    var username: String {
        return user.username
    }
    
    /// The date the person joined.
    var helpingSince: String {
        return "Helping since \(Self.formatter.string(from: user.createdAt))"
    }
    
    /// The total amount of love a person obtained.
    var totalLove: Int {
        return user.totalLove
    }
    
    /// The total amount of appreciation a person obtained.
    var totalAppreciation: Int {
        return user.totalAppreciation
    }
}
