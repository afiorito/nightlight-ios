/// All raw application strings displayed to the user.
public struct Strings {
    
    /// information for describing initial onboarding screens.
    static let onboard = [
        (title: "Spread positivity", subtitle: "The world could use more of it", image: "onboard_earth"),
        (title: "Make a difference", subtitle: "Send helpful, kind or motivational messages to others in need", image: "onboard_letter"),
        (title: "Show love and appreciation", subtitle: "Celebrate people who are trying to make an impact", image: "onboard_hand")
    ]
    
    struct externalPage {
        static let privacyPolicy = "Privacy Policy"
        static let termsOfUse = "Terms of Use"
        static let feedback = "Feedback"
        static let about = "About"
    }
    
    struct placeholder {
        static let username = "username"
        static let password = "password"
        static let email = "email"
    }
    
    struct error {
        static let usernameExists = "The username already exists."
        static let invalidUsername = "The username is invalid."
        static let weakPassword = "The password is too weak."
        static let emailExists = "A user with that email already exists."
        static let invalidEmail = "The email is invalid."
    }
    
    struct auth {
        static let signUpHeaderText = "Get\nStarted"
        static let signInHeaderText = "Welcome\nBack!"
        static let noAccount = "Don't have an account?"
        static let ownsAccount = "Already have an account?"
        static let signInButtonText = "Sign in"
        static let signUpButtonText = "Sign up"
    }
    
    static let agreeToTerms = "By signing up you agree to the\nTerms of Use and Privacy Policy"
    static let unavailableButtonText = "Unavailable"
    static let tokenPacksTitle = "Token Packs"
    static let confirmPurchaseButtonText = "Confirm Purchase"
}
