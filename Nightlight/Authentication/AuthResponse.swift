/// Server response for an authentication route.
public struct AuthResponse: Codable {
    /// A token to authenticate a user in future requests.
    let token: AuthToken
}
