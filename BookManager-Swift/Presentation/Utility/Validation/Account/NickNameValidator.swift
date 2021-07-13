import Foundation

enum NickNameValidator: ValidatorProtocol {
    typealias ValueType = String?
    typealias ErrorType = NickNameError

    static func validate(_ value: String?) -> ValidationResult<NickNameError> {
        guard
            let value = value,
            !value.isEmpty
        else {
            return .invalid(.empty)
        }

        return .valid
    }
}

enum NickNameError: LocalizedError {
    case empty

    var errorDescription: String? {
        switch self {
            case .empty:
                return Resources.Strings.Validation.notFilledNickName
        }
    }
}
