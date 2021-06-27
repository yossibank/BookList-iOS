import UIKit

final class ChatSelectRouting: Routing {
    weak var viewController: UIViewController?
}

extension ChatSelectRouting {

    func showChatUserListScreen() {
        let chatUserListVC = Resources.ViewControllers.App.chatUserList()
        let navVC = RootNavigationController(rootViewController: chatUserListVC)
        navVC.setupNavigationBar(
            forVC: chatUserListVC,
            config: chatUserListVC as NavigationBarConfiguration
        )

        viewController?.present(navVC, animated: true)
    }

    func showChatRoomScreen() {
        // push
    }
}
