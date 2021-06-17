import Foundation

@propertyWrapper
struct Localizable {
    var wrappedValue: String {
        didSet {
            self.wrappedValue = NSLocalizedString(self.wrappedValue, comment: "")
        }
    }

    init(wrappedValue: String) {
        self.wrappedValue = NSLocalizedString(wrappedValue, comment: "")
    }
}
