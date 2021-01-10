import Foundation

private let minimumLength = 6

enum PasswordValidator: ValidatorProtocol {
    typealias ValueType = String?
    typealias ErrorType = PasswordError

    static func validate(
        _ value: String?
    ) -> ValidationResult<PasswordError> {
        guard let value = value,
              !value.isEmpty
        else {
            return .invalid(.empty)
        }

        if value.count < minimumLength {
            return .invalid(.tooShort)
        }

        return .valid
    }
}

enum PasswordError: LocalizedError {
    case empty
    case tooShort

    var errorDescription: String? {

        switch self {

        case .empty:
            return Resources.Strings.Validator.passwordEmpty

        case .tooShort:
            return Resources.Strings.Validator.notFilledPassword
        }
    }
}
