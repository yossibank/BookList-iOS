import Combine
import DomainKit
import Utility

final class AddBookViewModel: ViewModel {
    typealias State = LoadingState<BookEntity, APPError>

    private let usecase: AddBookUsecase

    private var cancellables: Set<AnyCancellable> = []

    @Published var bookName = String.blank
    @Published var bookImage = String.blank
    @Published var bookPrice = String.blank
    @Published var bookPurchaseDate = String.blank
    @Published private(set) var state: State = .standby

    init(usecase: AddBookUsecase = Domain.Usecase.Book.AddBook()) {
        self.usecase = usecase
    }
}

// MARK: - internal methods

extension AddBookViewModel {

    func addBook() {
        usecase.addBook(
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
