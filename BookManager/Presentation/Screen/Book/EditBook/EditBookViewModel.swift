import Combine
import DomainKit
import Utility

final class EditBookViewModel: ViewModel {
    typealias State = LoadingState<BookEntity, APPError>

    @Published var bookName = String.blank
    @Published var bookImage = String.blank
    @Published var bookPrice = String.blank
    @Published var bookPurchaseDate = String.blank
    @Published private(set) var state: State = .standby

    private let id: Int
    private let usecase: EditBookUsecase

    private var cancellables: Set<AnyCancellable> = []

    init(
        book: BookBusinessModel,
        usecase: EditBookUsecase = Domain.Usecase.Book.EditBook()
    ) {
        self.id = book.id
        self.usecase = usecase
    }
}

// MARK: - internal methods

extension EditBookViewModel {

    func editBook() {
        usecase.updateBook(
            id: id,
            name: bookName,
            image: bookImage,
            price: Int(bookPrice),
            purchaseDate: bookPurchaseDate
        )
        .sink { [weak self] completion in
            switch completion {
                case let .failure(error):
                    Logger.debug(message: error.localizedDescription)
                    self?.state = .failed(.init(error: error))

                case .finished:
                    Logger.debug(message: "finished")
            }
        } receiveValue: { [weak self] state in
            self?.state = .done(state)
        }
        .store(in: &cancellables)
    }
}
