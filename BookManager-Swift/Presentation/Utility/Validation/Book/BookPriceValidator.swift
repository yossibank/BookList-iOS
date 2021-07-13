import Foundation

enum BookPriceValidator: ValidatorProtocol {
    typealias ValueType = String?
    typealias ErrorType = BookPriceError

    static func validate(_ value: String?) -> ValidationResult<BookPriceError> {
        guard
            let value = value,
            !value.isEmpty
        else {
            return .invalid(.empty)
        }

        let format = "[0-9]+"
        let isValidNumber = NSPredicate(
            format: "SELF MATCHES %@",
            format
        ).evaluate(with: value)

        if !isValidNumber {
            return .invalid(.onlyNumber)
        }

        return .valid
    }
}

enum BookPriceError: LocalizedError {
    case empty
    case onlyNumber

    var errorDescription: String? {
        switch self {
            case .empty:
                return Resources.Strings.Validation.notFilledBookPrice

            case .onlyNumber:
                return Resources.Strings.Validation.onlyInputNumber
        }
    }
}
