final class WishListViewModel {
    var books: [BookViewData] {
        BookFileManager.shared.fetchData()
    }
}
