public extension String {
    /**
     Returns a string with the first letter capitalized.
     */
    func capitalizingFirstLetter() -> String {
      return prefix(1).uppercased() + self.lowercased().dropFirst()
    }

    /**
     Capitalizes the first letter of the string.
     */
    mutating func capitalizeFirstLetter() {
      self = self.capitalizingFirstLetter()
    }
}
