import Foundation

@propertyWrapper
class UserDefaultsStorage<T: LosslessStringConvertible> {
    private let key: String

    init(key: String) {
        self.key = key
    }

    var wrappedValue: T? {
        get {
            UserDefaults.standard.object(forKey: key) as? T
        }
        set {
            UserDefaults.standard.set(newValue, forKey: key)
        }
    }
}
