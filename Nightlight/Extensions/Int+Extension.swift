extension Int {
    /// An abbreviation for integers larger than 1000.
    var abbreviated: String {
        let number = Double(self)
        let thousand = number / 1000.0
        let million = number / 1000000.0
        
        if million >= 1 {
            return "\((million * 10).rounded() / 10)m"
        } else if thousand >= 1 {
            return "\((thousand * 10).rounded() / 10)k"
        } else {
            return "\(self)"
        }
    }
}
