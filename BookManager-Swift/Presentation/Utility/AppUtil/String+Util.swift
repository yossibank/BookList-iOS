public extension String {

    static var blank: String {
        ""
    }

    static func toTaxText(_ price: Int?) -> String {
        guard
            let price = price
        else {
            return String.blank
        }

        return String(price)
            + Resources.Strings.Book.yen
            + "+"
            + Resources.Strings.Book.tax
    }
}
