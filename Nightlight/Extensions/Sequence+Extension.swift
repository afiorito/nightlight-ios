extension Sequence {
    /**
     Returns the longest possible subsequences of the sequence, in order, by using the predicate to split the sequence.
     
     - parameter isSeparator: A closure that returns true if its argument should be used to split the sequence; otherwise, false.
     */
    func splitBefore(separator isSeparator: (Iterator.Element) throws -> Bool) rethrows -> [AnySequence<Iterator.Element>] {
        var result: [AnySequence<Iterator.Element>] = []
        var subSequence: [Iterator.Element] = []
        
        var iterator = self.makeIterator()
        while let element = iterator.next() {
            if try isSeparator(element) {
                if !subSequence.isEmpty {
                    result.append(AnySequence(subSequence))
                }
                subSequence = [element]
            } else {
                subSequence.append(element)
            }
        }

        result.append(AnySequence(subSequence))
        return result
    }
}
