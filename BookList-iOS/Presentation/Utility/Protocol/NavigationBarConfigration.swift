protocol NavigationBarConfiguration {
    var navigationTitle: String? { get }
    var backButtonTitle: String? { get }
    var rightBarButton: [NavigationBarButton] { get }
}

extension NavigationBarConfiguration {
    var navigationTitle: String? { nil }
    var backButtonTitle: String? { nil }
    var rightBarButton: [NavigationBarButton] { [] }
}

enum NavigationBarButton {
    case logout
    case done
    case addUser
    case startTalk
}
