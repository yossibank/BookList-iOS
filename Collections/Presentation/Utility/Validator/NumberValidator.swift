import Foundation

enum NumberValidator: ValidatorProtocol {
    typealias ValueType = String?
    typealias ErrorType = NumberError

    static func validate(
        _ value: String?
    ) -> ValidationResult<NumberError> {
        guard let value = value,
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
            return .invalid(.format)
        }

        return .valid
    }
}

enum NumberError: LocalizedError {
    case empty
    case format

    var errorDescription: String? {

        switch self {

        case .empty:
            return Resources.Strings.Validator.priceEmpty

        case .format:
            return Resources.Strings.Validator.onlyNumber
        }
    }
}
