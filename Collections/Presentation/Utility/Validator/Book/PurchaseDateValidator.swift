import Foundation

enum PurchaseDateValidator: ValidatorProtocol {
    typealias ValueType = String?
    typealias ErrorType = PurchaseDateError

    static func validate(
        _ value: String?
    ) -> ValidationResult<PurchaseDateError> {
        guard let value = value,
              !value.isEmpty
        else {
            return .invalid(.empty)
        }

        return .valid
    }
}

enum PurchaseDateError: LocalizedError {
    case empty

    var errorDescription: String? {

        switch self {

        case .empty:
            return Resources.Strings.Validator.purchaseDateEmpty
        }
    }
}
