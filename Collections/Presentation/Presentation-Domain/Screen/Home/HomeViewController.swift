import UIKit

final class HomeViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private let router: RouterProtocol = Router()

    static func createInstance() -> HomeViewController {
        HomeViewController.instantiateInitialViewController()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
