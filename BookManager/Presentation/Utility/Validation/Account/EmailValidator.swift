import Foundation
import Utility

enum EmailValidator: ValidatorProtocol {
    typealias ValueType = String?
    typealias ErrorType = EmailError

    static func validate(_ value: String?) -> ValidationResult<EmailError> {
        guard
            let value = value,
            !value.isEmpty
        else {
            return .invalid(.empty)
        }

        do {
            let format = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
            let isValidEmail = try NSRegularExpression(pattern: format, options: [])
            let matches = isValidEmail.matches(
                in: value,
                options: [],
                range: .init(location: 0, length: value.count)
            )

            if matches.isEmpty {
                return .invalid(.format)
            }
        } catch {
            Logger.debug(message: error.localizedDescription)
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
                return Resources.Strings.Validation.notFilledEmail

            case .format:
                return Resources.Strings.Validation.notCorrectFormatEmail
        }
    }
}
