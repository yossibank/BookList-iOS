import Combine
import DomainKit
import Utility

final class EditBookViewModel: ViewModel {
    typealias State = LoadingState<BookEntity, APPError>

    private let id: Int
    private let usecase: EditBookUsecase

    private var cancellables: Set<AnyCancellable> = []

    @Published var bookName: String = String.blank
    @Published var bookImage: String = String.blank
    @Published var bookPrice: String = String.blank
    @Published var bookPurchaseDate: String = String.blank
    @Published private(set) var state: State = .standby

    init(id: Int, usecase: EditBookUsecase = Domain.Usecase.Book.EditBook()) {
        self.id = id
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
                Logger.debug(error.localizedDescription)
                self?.state = .failed(.init(error: error))

            case .finished:
                Logger.debug("finished")
            }
        } receiveValue: { [weak self] state in
            self?.state = .done(state)
        }
        .store(in: &cancellables)
    }
}
