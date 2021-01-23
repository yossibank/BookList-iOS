import Foundation

enum TitleValidator: ValidatorProtocol {
    typealias ValueType = String?
    typealias ErrorType = TitleError

    static func validate(
        _ value: String?
    ) -> ValidationResult<TitleError> {
        guard let value = value,
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

enum TitleError: LocalizedError {
    case empty
    case longer

    var errorDescription: String? {

        switch self {

        case .empty:
            return Resources.Strings.Validator.titleEmpty

        case .longer:
            return Resources.Strings.Validator.notLognerTitleText
        }
    }
}
