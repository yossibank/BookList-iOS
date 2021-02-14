import RxSwift
import RxRelay

final class BookListViewModel {
    private let usecase: BookListUsecase!
    private let bookListRelay: BehaviorRelay<[BookListResponse.Book]> = BehaviorRelay(value: [])
    private let loadingRelay: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    private let errorRelay: BehaviorRelay<Error?> = BehaviorRelay(value: nil)
    private let disposeBag: DisposeBag = DisposeBag()

    var bookList: Observable<[BookViewData]?> {
        bookListRelay.asObservable()
            .map { [weak self] book in
                self?.map(book: book)
        }
    }

    var loading: Observable<Bool> {
        loadingRelay.asObservable()
    }

    var error: Observable<Error?> {
        errorRelay.asObservable()
    }

    init(usecase: BookListUsecase) {
        self.usecase = usecase
        bindUsecase()
    }

    private func bindUsecase() {
        usecase.bookList
            .bind(to: bookListRelay)
            .disposed(by: disposeBag)

        usecase.loading
            .bind(to: loadingRelay)
            .disposed(by: disposeBag)

        usecase.error
            .bind(to: errorRelay)
            .disposed(by: disposeBag)
    }

    private func map(book: [BookListResponse.Book]) -> [BookViewData] {
        let books = book.map { book in
            BookViewData(
                id: book.id,
                name: book.name,
                image: book.image,
                price: book.price,
                purchaseDate: book.purchaseDate,
                isFavorite: BookFileManager.shared.isFavoriteBook(path: String(book.id))
            )
        }
        return books
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

    func fetchBookList(isInitial: Bool) {
        usecase.fetchBookList(isInitial: isInitial)
    }
}
