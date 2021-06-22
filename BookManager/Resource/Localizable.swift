import Foundation

@propertyWrapper
struct Localizable {
    var wrappedValue: String {
        didSet {
            wrappedValue = NSLocalizedString(wrappedValue, comment: "")
        }
    }

    init(wrappedValue: String) {
        self.wrappedValue = NSLocalizedString(wrappedValue, comment: "")
    }
}
