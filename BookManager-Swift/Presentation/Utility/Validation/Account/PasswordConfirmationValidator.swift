import Foundation

enum PasswordConfirmationValidator: ValidatorProtocol {
    typealias ValueType = String?
    typealias ErrorType = PasswordConfirmationError

    static func validate(_ value: String?) -> ValidationResult<PasswordConfirmationError> {
        guard
            let value = value,
            !value.isEmpty
        else {
            return .invalid(.empty)
        }

        return .valid
    }

    static func validate(
        _ password: String,
        _ passwordConfirmation: String
    ) -> ValidationResult<PasswordConfirmationError> {
        if passwordConfirmation.isEmpty {
            return .invalid(.empty)
        }

        if password != passwordConfirmation {
            return .invalid(.notMatch)
        }

        return .valid
    }
}

enum PasswordConfirmationError: LocalizedError {
    case empty
    case notMatch

    var errorDescription: String? {
        switch self {
            case .empty:
                return Resources.Strings.Validation.notFilledPasswordConfirmation

            case .notMatch:
                return Resources.Strings.Validation.notMatchingPassowrd
        }
    }
}
