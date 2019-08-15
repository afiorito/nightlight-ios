import Foundation

/// A view model for handling a person.
public class PersonViewModel {
    
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
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM YYYY"
        return "Helping since \(formatter.string(from: user.createdAt))"
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
