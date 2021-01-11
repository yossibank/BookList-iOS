import UIKit

final class BookListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    static func createInstance() -> BookListViewController {
        BookListViewController.instantiateInitialViewController()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
