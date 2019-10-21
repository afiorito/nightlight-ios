/// All raw application strings displayed to the user.
public struct Strings {
    static let cancel = "Cancel"
    static let delete = "Delete"
    static let report = "Report"
    static let sendAppreciation = "Send Appreciation"
    static let getTokens = "Get Tokens"
    static let appreciationDescription = "Let’s the person know you appreciate them and increases the appreciation on their message."
    static let tokenCount = "Token count"
    static let couldNotLoadProducts = "Could not load products."
    static let signOut = "Sign Out"
    static let nightlightTokens = "Nightlight Tokens"
    static let emailChangedSuccessfully = "Email changed successfully."
    static let passwordChangedSuccessfully = "Password changed successfully."
    static let passwordResetSuccessfully = "Password reset successfully."
    static let sendResetEmail = "Send Reset Email"
    static let forgotPassword = "Forgot your password?"
    static let passwordReset = "Password Reset"
    static let resetPassword = "Reset Password"
    
    /// information for describing initial onboarding screens.
    struct onboard {
        static let pages = [
            (title: "Spread positivity", subtitle: "The world could use more of it.", image: "onboard_spread"),
            (title: "Make a difference", subtitle: "Every message you send is received by up to 5 random people. You can make someone's day better by sending a message.", image: "onboard_difference"),
            (title: "Show love and appreciation", subtitle: "Celebrate people who are trying to make an impact.", image: "onboard_send")
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
        static let resetEmail = "reset email"
        static let currentPassword = "current password"
        static let newPassword = "new password"
    }
    
    struct error {
        static let couldNotConnect = "Could not connect to Nightlight."
        static let unknown = "An unknown error occured."
        static let somethingWrong = "Something Went Wrong."
        static let mailNotConfigured = "Mail is not configured on this device."
        static let couldNotLoadAccount = "Could not load account information."
        static let invalidResetLink = "The reset link used is no longer valid."
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
        static let postMessageTabTitle = "Post"
        static let sendMessageTitle = "New Message"
        static let detailTitle = "Message"
        static let reported = "The message has been reported!"
        static let sendAnonymously = "Send Anonymously"
        static let numPeople = "People to send to (1-5)"
        static let deleteMessage = "Delete Message"
        static let confirmDelete = "Are you sure you want to delete this message? This action is irreversible."
        static let notFound = "The message could not be found."
    }
    
    struct profile {
        static let profileTitle = "Profile"
        static let helpingSince = "Helping Since"
    }
    
    struct search {
        static let searchTitle = "Search"
    }
    
    struct notification {
        static let notificationsTitle = "Notifications"
    }
    
    struct permission {
        struct notification {
            static let confirmTitle = "Turn On Notifications"
            static let cancelTitle = "No Thanks"
            static let title = "Never miss out"
            static let subtitle = "Get notified when someone interacts with your content."
        }
    }
    
    struct setting {
        static let settingsTitle = "Settings"
        static let accountSettingsTitle = "Account Settings"
        static let theme = "Theme"
        static let sendMessage = "Send Message As"
        static let sendFeedback = "Send Feedback"
        static let rateNightlight = "Please Rate Nightlight"
        static let about = "About"
        static let privacyPolicy = "Privacy Policy"
        static let termsOfUse = "Terms of Use"
        static let account = "Account"
        static let email = "Email"
        static let changePassword = "Change Password"
        static let changeEmail = "Change Email"
        static let confirmNewEmail = "Confirm New Email"
        static let confirmNewPassword = "Confirm New Password"
        static func ratingCount(_ count: Int) -> String {
            let prefix: String
            
            if count == 1 {
                prefix = "Only \(count) person"
            } else if (2...50) ~= count {
                prefix = "Only \(count) people"
            } else {
                prefix = "\(count) people"
            }
            
            return "\(prefix) rated this version."
        }
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
        static let incorrectPassword = "The current password does not match."
        static let emailExists = "A user with that email already exists."
        static let invalidEmail = "The email is invalid."
        static let failedSignIn = "Username or password are incorrect."
    }
    
    static let noProductsFound = "No Products Found."
    static let agreeToTerms = "By signing up you agree to the\nTerms of Use and Privacy Policy"
    static let unavailableButtonText = "Unavailable"
    static let tokenPacksTitle = "Token Packs"
    static let confirmPurchaseButtonText = "Confirm Purchase"
}
