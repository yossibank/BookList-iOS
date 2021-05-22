import KeychainAccess
import Foundation

final class KeychainManager {

    private struct Constant {
        static let identifier = "CFBundleIdentifier"
        static let token: String = "token"
    }

    private var keychain: Keychain = {
        guard
            let identifier = Bundle.main.object(
                forInfoDictionaryKey: Constant.identifier
            ) as? String
        else {
            return Keychain(service: .blank)
        }
        return Keychain(service: identifier)
    }()

    static let shared = KeychainManager()

    private init() { }

    func setToken(_ token: String) {
        do {
            try keychain.set(token, key: Constant.token)
        } catch {
            Logger.error("can't set \(Constant.token)")
        }
    }

    func getToken() -> String? {
        try? keychain.get(Constant.token)
    }

    func removeToken() {
        do {
            try keychain.remove(Constant.token)
        } catch {
            Logger.error("can't remove \(Constant.token)")
        }
    }
}
