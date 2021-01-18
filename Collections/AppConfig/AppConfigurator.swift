import  Foundation

final class AppConfigurator {
    
    private struct Constant {
        static let apiUrl = "http://54.250.239.8"
    }

    static var currentApiUrl: URL {
        let path: URL? = URL(string: Constant.apiUrl)
        return path ?? URL(string: .blank)!
    }
}
