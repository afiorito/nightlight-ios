/// Necessary credentials for signing up a user.
public struct SignUpCredentials: Codable {
    let username: String
    let email: String
    let password: String
}
