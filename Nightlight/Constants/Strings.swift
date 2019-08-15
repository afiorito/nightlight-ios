/// All raw application strings displayed to the user.
public struct Strings {
    
    /// information for describing initial onboarding screens.
    struct onboard {
        static let pages = [
            (title: "Spread positivity", subtitle: "The world could use more of it", image: "onboard_earth"),
            (title: "Make a difference", subtitle: "Send helpful, kind or motivational messages to others in need", image: "onboard_letter"),
            (title: "Show love and appreciation", subtitle: "Celebrate people who are trying to make an impact", image: "onboard_hand")
        ]
        
        static let getStarted = "Get Started"
        static let signIn = "Sign In"
    }
    
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
        static let couldNotConnect = "Could not connect to Nightlight."
        static let unknown = "An unknown error occured."
    }

    struct message {
        static let invalidTitle = "Message title is invalid."
        static let titleTooLong = "Message title is too long."
        static let titleTooShort = "Message title is too short."
        static let bodyTooShort = "Message body is too short."
        static let bodyTooLong = "Message body is too long."
        static let invalidyBody = "Message body is invalid."
        static let invalidNumPeople = "Number of people is invalid."
        static let insufficientTokens = "Insufficient tokens."
        static let alreadyAppreciated = "Message is already appreciated."
        static let recentMessagesNavTitle = "Recent Messages"
        static let recentMessagesTabTitle = "Recent"
        static let sendMessageTitle = "New Message"
        static let detailTitle = "Message"
        static let reported = "The message has been reported!"
        static let sendAnonymously = "Send Anonymously"
        static let numPeople = "People to send to (1-5)"
    }
    
    struct notification {
        static let notificationsTitle = "Notifications"
    }
    
    struct auth {
        static let signUpHeaderText = "Get\nStarted"
        static let signInHeaderText = "Welcome\nBack!"
        static let noAccount = "Don't have an account?"
        static let ownsAccount = "Already have an account?"
        static let signInButtonText = "Sign in"
        static let signUpButtonText = "Sign up"
        static let usernameExists = "The username already exists."
        static let invalidUsername = "The username is invalid."
        static let weakPassword = "The password is too weak."
        static let emailExists = "A user with that email already exists."
        static let invalidEmail = "The email is invalid."
    }
    
    static let agreeToTerms = "By signing up you agree to the\nTerms of Use and Privacy Policy"
    static let unavailableButtonText = "Unavailable"
    static let tokenPacksTitle = "Token Packs"
    static let confirmPurchaseButtonText = "Confirm Purchase"
}
