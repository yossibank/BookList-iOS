import UIKit

struct HomeCellData {
    let title: String
    let image: UIImage?
    
    enum HomeItem: CaseIterable {
        typealias RawValue = HomeCellData

        case bookList
        case wishList

        var rawValue: RawValue {
            switch self {

            case .bookList:
                return HomeCellData(
                    title: Resources.Strings.Home.bookList,
                    image: Resources.Images.Home.bookList
                )

            case .wishList:
                return HomeCellData(
                    title: Resources.Strings.Home.wishList,
                    image: Resources.Images.Home.wishList
                )
            }
        }
    }
}
