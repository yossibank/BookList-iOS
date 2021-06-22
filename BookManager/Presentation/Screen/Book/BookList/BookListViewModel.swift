import Combine
import DomainKit
import Utility

final class BookListViewModel: ViewModel {
    typealias State = LoadingState<[BookEntity], APPError>

    private let usecase: BookListUsecase

    private var cancellables: Set<AnyCancellable> = []
    private var pageRequest: Int = 1

    private(set) var bookList: [BookViewData] = []
    @Published private(set) var state: State = .standby

    init(usecase: BookListUsecase = Domain.Usecase.Book.FetchBookList()) {
        self.usecase = usecase
    }
}

// MARK: - internal methods

extension BookListViewModel {

    func fetchBookList() {
        state = .loading

        usecase
            .fetchBookList(pageRequest: pageRequest)
            .sink { [weak self] completion in
                switch completion {
                    case let .failure(error):
                        Logger.debug(message: error.localizedDescription)
                        self?.state = .failed(.init(error: error))

                    case .finished:
                        Logger.debug(message: "finished")
                        self?.pageRequest += 1
                }
            } receiveValue: { [weak self] state in
                guard let self = self else { return }
                self.bookList.append(contentsOf: self.map(book: state))
                self.state = .done(state)
            }
            .store(in: &cancellables)
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
}

// MARK: - private methods

private extension BookListViewModel {

    func map(book: [BookEntity]) -> [BookViewData] {
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
}
