import UIKit

final class ChatSelectViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    static func createInstance() -> ChatSelectViewController {
        let instance = ChatSelectViewController.instantiateInitialViewController()
        return instance
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
