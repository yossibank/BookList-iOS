import RxSwift
import RxRelay

final class BookListUsecase {
    private let resultSubject: BehaviorRelay<Result<BookListResponse, Error>?> = BehaviorRelay(value: nil)
    private let disposeBag: DisposeBag = DisposeBag()

    private(set) var currentPage: Int = 1
    private(set) var totalPage: Int = 0
    private(set) var limit: Int = 20

    private var isNextPage: Bool {
        currentPage > totalPage && totalPage != 0
    }

    var result: Observable<Result<BookListResponse, Error>?> {
        resultSubject.asObservable()
    }

    var books: [Book] = []

    func fetchBookList(isInitial: Bool) {

        currentPage = isInitial ? 1 : currentPage + 1

        if isNextPage { return }

        BookListRequest().request(.init(limit: limit, page: currentPage))
            .subscribe(onSuccess: { response in
                self.resultSubject.accept(.success(response))
                self.books.append(contentsOf: response.result)
                self.totalPage = response.totalPages
            }, onFailure: { error in
                self.resultSubject.accept(.failure(error))
            })
            .disposed(by: disposeBag)
    }
}
