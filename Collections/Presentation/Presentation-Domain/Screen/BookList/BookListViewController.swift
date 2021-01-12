import UIKit
import RxSwift
import RxCocoa

final class BookListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    private let disposeBag: DisposeBag = DisposeBag()

    private var viewModel: BookListViewModel!
    private var dataSource: BookListDataSource!

    static func createInstance(viewModel: BookListViewModel) -> BookListViewController {
        let instance = BookListViewController.instantiateInitialViewController()
        instance.viewModel = viewModel
        return instance
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        bindViewModel()
    }
}

extension BookListViewController {

    private func setupTableView() {
        dataSource = BookListDataSource(viewModel: viewModel)

        tableView.register(BookListTableViewCell.xib(), forCellReuseIdentifier: BookListTableViewCell.resourceName)
        tableView.dataSource = dataSource
        tableView.rowHeight = 100
    }
}

extension BookListViewController {

    private func bindViewModel() {
        viewModel.fetchBookList(isInitial: true)

        viewModel.result
            .asDriver(onErrorJustReturn: nil)
            .drive(onNext: { [weak self] result in
                guard let self = self,
                      let result = result else { return }

                switch result {

                case .success(let response):
                    dump(response)
                    self.tableView.reloadData()

                case .failure(let error):
                    dump(error)
                }
            })
            .disposed(by: disposeBag)
    }
}
