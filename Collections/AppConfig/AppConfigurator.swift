import  Foundation

final class AppConfigrator {

    static var currentApiUrl: URL {
        let path: URL? = URL(string: "http://54.250.239.8")
        return path ?? URL(string: .blank)!
    }
}
