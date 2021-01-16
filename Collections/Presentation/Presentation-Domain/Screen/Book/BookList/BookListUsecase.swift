import RxSwift
import RxRelay

final class BookListUsecase {
    private let loadingSubject: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    private let resultSubject: BehaviorRelay<Result<BookListResponse, Error>?> = BehaviorRelay(value: nil)
    private let disposeBag: DisposeBag = DisposeBag()

    private(set) var currentPage: Int = 1
    private(set) var totalPage: Int = 0
    private(set) var limit: Int = 20

    private var isNextPage: Bool {
        currentPage > totalPage && totalPage != 0
    }

    var loading: Observable<Bool> {
        loadingSubject.asObservable()
    }

    var result: Observable<Result<BookListResponse, Error>?> {
        resultSubject.asObservable()
    }

    var books: [BookListResponse.Book] = []

    func fetchBookList(isInitial: Bool) {

        currentPage = isInitial ? 1 : currentPage + 1

        if isNextPage { return }

        loadingSubject.accept(true)

        BookListRequest().request(.init(limit: limit, page: currentPage))
            .subscribe(onSuccess: { response in
                self.loadingSubject.accept(false)
                self.resultSubject.accept(.success(response))
                self.totalPage = response.totalPages
                self.books.append(contentsOf: response.result)
            }, onFailure: { error in
                self.loadingSubject.accept(false)
                self.resultSubject.accept(.failure(error))
            })
            .disposed(by: disposeBag)
    }
}
