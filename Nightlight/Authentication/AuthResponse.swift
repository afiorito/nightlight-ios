/// Server response for an authentication route.
public struct AuthResponse: Codable {
    let token: AuthToken
}
