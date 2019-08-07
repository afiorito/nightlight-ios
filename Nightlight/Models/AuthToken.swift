/// The object for representing an auth token.
public struct AuthToken: Codable {
    /// The access token represented as a jwt string.
    let access: String
    
    /// The refresh token for reauthenticating after the jwt token expires.
    let refresh: String
}
