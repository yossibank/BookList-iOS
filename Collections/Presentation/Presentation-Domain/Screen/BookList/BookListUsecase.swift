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

    var books: [BookListItem] = []

    func fetchBookList(isInitial: Bool) {

        currentPage = isInitial ? 1 : currentPage + 1

        if isNextPage { return }

        BookListRequest().request(.init(limit: limit, page: currentPage))
            .subscribe(onSuccess: { response in
                self.resultSubject.accept(.success(response))
                self.totalPage = response.totalPages
                self.books = self.map(book: response.result)
            }, onFailure: { error in
                self.resultSubject.accept(.failure(error))
            })
            .disposed(by: disposeBag)
    }

    func map(book: [Book]) -> [BookListItem] {
        let books = book.map {
            BookListItem(
                name: $0.name,
                image: $0.image,
                price: $0.price,
                purchaseDate: $0.purchaseDate
            )
        }
        return books
    }
}
