import UIKit

final class ChatRoomViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    static func createInstance() -> ChatRoomViewController {
        let instance = ChatRoomViewController.instantiateInitialViewController()
        return instance
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
