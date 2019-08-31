import UIKit

extension UIImage {
    struct icon {
        static var cancel: UIImage? { return UIImage(named: "icon_cancel") }
        static var person: UIImage? { return UIImage(named: "icon_person") }
        static var lock: UIImage? { return UIImage(named: "icon_lock") }
        static var mail: UIImage? { return UIImage(named: "icon_mail") }
        static var context: UIImage? { return UIImage(named: "icon_context") }
        static var back: UIImage? { return UIImage(named: "icon_back") }
        static var info: UIImage? { return UIImage(named: "icon_info") }
        static var logo: UIImage? { return UIImage(named: "icon_logo") }
        static var flag: UIImage? { return UIImage(named: "icon_flag") }
        static var trash: UIImage? { return UIImage(named: "icon_trash") }
        static var check: UIImage? { return UIImage(named: "icon_check") }
        static var settings: UIImage? { return UIImage(named: "icon_settings") }
        static var urgent: UIImage? { return UIImage(named: "icon_urgent") }
        static var send: UIImage? { return UIImage(named: "icon_send") }
        static var messageSelected: UIImage? { return UIImage(named: "icon_message--selected") }
        static var heartSelected: UIImage? { return UIImage(named: "icon_heart--selected") }
        static var heartUnselected: UIImage? { return UIImage(named: "icon_heart--unselected") }
        static var sunSelected: UIImage? { return UIImage(named: "icon_sun--selected") }
        static var sunUnselected: UIImage? { return UIImage(named: "icon_sun--unselected") }
        static var bookmarkSelected: UIImage? { return UIImage(named: "icon_bookmark--selected") }
        static var bookmarkUnselected: UIImage? { return UIImage(named: "icon_bookmark--unselected") }
        
    }
    
    struct tab {
        static var recent: UIImage? { return UIImage(named: "tb_recent") }
        static var notification: UIImage? { return UIImage(named: "tb_notification") }
        static var profile: UIImage? { return UIImage(named: "tb_profile") }
        static var search: UIImage? { return UIImage(named: "tb_search") }
        static var post: UIImage? { return UIImage(named: "tb_post") }
    }
    
    struct empty {
        static var message: UIImage? { return UIImage(named: "empty_message") }
        static var notification: UIImage? { return UIImage(named: "empty_notifications") }
    }
    
    struct glyph {
        static var token: UIImage? { return UIImage(named: "glyph_token") }
        static var disclosure: UIImage? { return UIImage(named: "glyph_disclosure") }
    }
    
    static var fullLogo: UIImage? {
        return UIImage(named: "logo_full")
    }
}
