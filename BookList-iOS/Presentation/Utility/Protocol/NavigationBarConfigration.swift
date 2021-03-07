protocol NavigationBarConfiguration {
    var navigationTitle: String? { get }
    var backButtonTitle: String? { get }
}

extension NavigationBarConfiguration {
    var navigationTitle: String? { nil }
    var backButtonTitle: String? { nil }
}
