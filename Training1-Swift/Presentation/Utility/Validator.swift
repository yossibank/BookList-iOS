protocol ValidatorProtocol {
    associatedtype ValueType
    associatedtype ErrorType: Error
    static func validate(_ value: ValueType) -> ValidationResult<ErrorType>
}

enum ValidationResult<E: Error> {
    case valid
    case invalid(E)

    var isValid: Bool {
        if case .valid = self {
            return true
        }
        return false
    }

    var errorDescription: String? {
        if case let .invalid(error) = self {
            return error.localizedDescription
        }
        return nil
    }
}
