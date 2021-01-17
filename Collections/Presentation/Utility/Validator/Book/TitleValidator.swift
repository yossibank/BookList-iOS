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

        return .valid
    }
}

enum TitleError: LocalizedError {
    case empty

    var errorDescription: String? {

        switch self {

        case .empty:
            return Resources.Strings.Validator.titleEmpty
        }
    }
}
