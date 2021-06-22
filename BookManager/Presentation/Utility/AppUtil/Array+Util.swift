extension Array where Element: Any {

    func any(at position: Int) -> Element? {
        if position < startIndex || position >= endIndex {
            return nil
        }
        return self[position]
    }

    func any(at position: Int?) -> Element? {
        if let position = position {
            return any(at: position)
        }
        return nil
    }
}
