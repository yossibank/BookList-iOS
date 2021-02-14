import RxSwift
import RxRelay

final class BookListUsecase {
    private let bookListRelay: BehaviorRelay<[BookListResponse.Book]> = BehaviorRelay(value: [])
    private let loadingRelay: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    private let errorRelay: BehaviorRelay<Error?> = BehaviorRelay(value: nil)
    private let disposeBag: DisposeBag = DisposeBag()

    private var currentPage: Int = 1
    private var totalPage: Int = 0
    private var limit: Int = 20
    private var isNextPage: Bool {
        currentPage > totalPage && totalPage != 0
    }

    var bookList: Observable<[BookListResponse.Book]> {
        bookListRelay.asObservable()
    }

    var loading: Observable<Bool> {
        loadingRelay.asObservable()
    }

    var error: Observable<Error?> {
        errorRelay.asObservable()
    }

    func fetchBookList(isInitial: Bool) {

        currentPage = isInitial ? 1 : currentPage + 1

        if isNextPage { return }

        loadingRelay.accept(true)

        BookListRequest()
            .request(
                .init(
                    limit: limit,
                    page: currentPage
                )
            )
            .subscribe(
                onSuccess: { [weak self] response in
                    self?.bookListRelay.accept(response.result)
                    self?.loadingRelay.accept(false)
                    self?.totalPage = response.totalPages
                },
                onFailure: { [weak self] error in
                    self?.loadingRelay.accept(false)
                    self?.errorRelay.accept(error)
                })
            .disposed(by: disposeBag)
    }
}
