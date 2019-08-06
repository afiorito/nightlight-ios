/// Necessary credentials for signing in a user.
public struct SignInCredentials: Codable {
    let username: String
    let password: String
}
