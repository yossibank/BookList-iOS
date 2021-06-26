import Foundation

enum NameValidator: ValidatorProtocol {
    typealias ValueType = String?
    typealias ErrorType = NameError

    static func validate(
        _ value: String?
    ) -> ValidationResult<NameError> {
        guard
            let value = value,
            !value.isEmpty
        else {
            return .invalid(.empty)
        }

        return .valid
    }
}

enum NameError: LocalizedError {
    case empty

    var errorDescription: String? {

        switch self {

            case .empty:
                return Resources.Strings.Validation.notFilled
        }
    }
}
