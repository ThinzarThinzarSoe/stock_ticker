
extension Collection {
    func randomElements(_ count: Int) -> [Element] {
        var shuffledIterator = shuffled().makeIterator()
        return (0..<count).compactMap { _ in shuffledIterator.next() }
    }
}
