import  Foundation

final class AppConfigurator {

    static var currentApiUrl: URL {
        let path: URL? = URL(string: Resources.Strings.API.apiBaseUrl)
        return path ?? URL(string: .blank)!
    }
}
