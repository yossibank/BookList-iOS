import Foundation

enum EmailValidator: ValidatorProtocol {
    typealias ValueType = String?
    typealias ErrorType = EmailError

    static func validate(
        _ value: String?
    ) -> ValidationResult<EmailError> {
        guard
            let value = value,
            !value.isEmpty
        else {
            return .invalid(.empty)
        }

        let format = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let isValidemail = NSPredicate(
            format: "SELF MATCHES %@",
            format
        ).evaluate(with: value)

        if !isValidemail {
            return .invalid(.format)
        }

        return .valid
    }
}

enum EmailError: LocalizedError {
    case empty
    case format

    var errorDescription: String? {

        switch self {

            case .empty:
                return Resources.Strings.Validation.notFilled

            case .format:
                return Resources.Strings.Validation.notFilled
        }
    }
}
