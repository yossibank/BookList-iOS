import  Foundation

final class AppConfigurator {

    static var currentApiUrl: URL {
        let path: URL? = URL(string: "")
        return path ?? URL(string: .blank)!
    }
}
