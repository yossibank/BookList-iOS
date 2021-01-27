import RxSwift
import RxRelay

final class BookListViewModel {
    private let usecase: BookListUsecase!
    private let loadingSubject: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    private let resultSubject: BehaviorRelay<Result<BookListResponse, Error>?> = BehaviorRelay(value: nil)
    private let disposeBag: DisposeBag = DisposeBag()

    var loading: Observable<Bool> {
        loadingSubject.asObservable()
    }

    var result: Observable<Result<BookListResponse, Error>?> {
        resultSubject.asObservable()
    }

    var books: [BookViewData] {
        map(book: usecase.books)
    }

    init(usecase: BookListUsecase) {
        self.usecase = usecase
        bindUsecase()
    }

    private func bindUsecase() {
        usecase.loading
            .bind(to: loadingSubject)
            .disposed(by: disposeBag)

        usecase.result
            .bind(to: resultSubject)
            .disposed(by: disposeBag)
    }

    func getBookId(index: Int) -> Int? {
        books.any(at: index)?.id
    }

    func saveFavoriteBook(book: BookViewData) {
        BookFileManager.shared.setData(
            path: String(book.id),
            data: book.json
        )
    }

    func removeFavoriteBook(book: BookViewData) {
        BookFileManager.shared.removeData(
            path: String(book.id)
        )
    }

    func resetBookData() {
        usecase.books = []
    }

    func fetchBookList(isInitial: Bool) {
        usecase.fetchBookList(isInitial: isInitial)
    }
}

extension BookListViewModel {

    private func map(book: [BookListResponse.Book]) -> [BookViewData] {
        let books = book.map { book in
            BookViewData(
                id: book.id,
                name: book.name,
                image: book.image,
                price: book.price,
                purchaseDate: book.purchaseDate,
                isFavorite: BookFileManager.shared.isFavorite(path: String(book.id))
            )
        }
        return books
    }
}
