public extension String {

    static var blank: String {
        ""
    }

    static func toTaxText(_ price: Int) -> String {
        String(price)
            + Resources.Strings.Book.yen
            + Resources.Strings.Book.tax
    }
}
