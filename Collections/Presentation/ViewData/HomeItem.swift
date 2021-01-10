import UIKit

struct Item {
    let title: String
    let image: UIImage?
}

enum CellItem: CaseIterable {
    typealias RawValue = Item

    case bookList
    case wishList

    var rawValue: RawValue {
        switch self {

        case .bookList:
            return Item(title: "書籍一覧", image: Resources.Images.Home.bookList)

        case .wishList:
            return Item(title: "お気に入り書籍", image: Resources.Images.Home.wishList)
        }
    }
}
