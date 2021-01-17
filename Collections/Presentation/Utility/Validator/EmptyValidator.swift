import Foundation

enum EmptyValidator: ValidatorProtocol {
    typealias ValueType = String?
    typealias ErrorType = EmptyError

    static func validate(
        _ value: String?
    ) -> ValidationResult<EmptyError> {
        guard let value = value,
              !value.isEmpty
        else {
            return .invalid(.empty)
        }

        return .valid
    }
}

enum EmptyError: LocalizedError {
    case empty

    var errorDescription: String? {

        switch self {

        case .empty:
            return Resources.Strings.Validator.titleEmpty
        }
    }
}
