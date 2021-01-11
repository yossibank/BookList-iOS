import UIKit
import RxSwift
import RxCocoa

final class BookListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    private let disposeBag: DisposeBag = DisposeBag()

    private var viewModel: BookListViewModel!

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
        tableView.register(BookListTableViewCell.xib(), forCellReuseIdentifier: BookListTableViewCell.resourceName)
        tableView.dataSource = self
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

extension BookListViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.books.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: BookListTableViewCell.resourceName,
            for: indexPath
        ) as? BookListTableViewCell ?? BookListTableViewCell()

        cell.setup(book: viewModel.books[indexPath.row])

        return cell
    }
}
