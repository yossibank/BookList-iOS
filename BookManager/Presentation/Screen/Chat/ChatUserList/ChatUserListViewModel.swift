import RxSwift
import RxRelay

final class ChatUserListViewModel: ViewModel {
    private let usecase: ChatUserListUsecase!
    private let userListRelay: BehaviorRelay<[User]> = BehaviorRelay(value: [])
    private let errorRelay: BehaviorRelay<Error?> = BehaviorRelay(value: nil)
    private let disposeBag = DisposeBag()

    var userList: Observable<[User]> {
        userListRelay.asObservable()
    }

    var error: Observable<Error?> {
        errorRelay.asObservable()
    }

    init(usecase: ChatUserListUsecase) {
        self.usecase = usecase
        bindUsecase()
    }

    private func bindUsecase() {
        usecase.userList
            .bind(to: userListRelay)
            .disposed(by: disposeBag)

        usecase.error
            .bind(to: errorRelay)
            .disposed(by: disposeBag)
    }

    func createRoom(partnerUser: User) {
        FirestoreManager.shared.createRoom(partnerUser: partnerUser)
    }

    func fetchUsers() {
        usecase.fetchUserList()
    }
}
