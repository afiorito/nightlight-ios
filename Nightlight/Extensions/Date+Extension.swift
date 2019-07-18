import Foundation

extension Date {
    public func ago() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        
        let fullDate = dateFormatter.string(from: self)

        let dateComponents = Calendar.current.dateComponents([.second, .minute, .hour, .day], from: self.toLocalTime(), to: Date().toLocalTime())
        
        guard let day = dateComponents.day,
            let hour = dateComponents.hour,
            let minute = dateComponents.minute,
            let second = dateComponents.second
        else {
            return fullDate
        }
        
        if day > 1 {
            return fullDate
        } else if day > 0 {
            return "1d"
        } else if hour > 0 {
            return "\(hour)h"
        } else if minute > 0 {
            return "\(minute)m"
        } else if second > 0 {
            return "\(second)s"
        } else {
            return "now"
        }
    }
    
    public func toLocalTime() -> Date {
        let timezone = TimeZone.current
        let seconds = TimeInterval(timezone.secondsFromGMT(for: self))
        return Date(timeInterval: seconds, since: self)
    }
}
