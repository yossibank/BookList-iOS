import Foundation

enum BookPurchaseDateValidator: ValidatorProtocol {
    typealias ValueType = String?
    typealias ErrorType = BookPurchaseDateError

    static func validate(_ value: String?) -> ValidationResult<BookPurchaseDateError> {
        guard
            let value = value,
            !value.isEmpty
        else {
            return .invalid(.empty)
        }

        return .valid
    }
}

enum BookPurchaseDateError: LocalizedError {
    case empty

    var errorDescription: String? {
        switch self {
            case .empty:
                return Resources.Strings.Validation.notFilledBookPurchaseDate
        }
    }
}
