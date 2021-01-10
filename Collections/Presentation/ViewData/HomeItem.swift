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
            return Item(
                title: Resources.Strings.Home.bookList,
                image: Resources.Images.Home.bookList
            )

        case .wishList:
            return Item(
                title: Resources.Strings.Home.wishList,
                image: Resources.Images.Home.wishList
            )
        }
    }
}
