import Foundation

enum BookTitleValidator: ValidatorProtocol {
    typealias ValueType = String?
    typealias ErrorType = BookTitleError

    static func validate(_ value: String?) -> ValidationResult<BookTitleError> {
        guard
            let value = value,
            !value.isEmpty
        else {
            return .invalid(.empty)
        }

        guard value.count <= 30 else {
            return .invalid(.longer)
        }

        return .valid
    }
}

enum BookTitleError: LocalizedError {
    case empty
    case longer

    var errorDescription: String? {
        switch self {
            case .empty:
                return Resources.Strings.Validation.notFilledBookTitle

            case .longer:
                return Resources.Strings.Validation.notLongerTitleText
        }
    }
}
