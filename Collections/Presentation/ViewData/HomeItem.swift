import UIKit

struct Item {
    let title: String
    let image: UIImage?
}

enum CellItem: CaseIterable {
    typealias RawValue = Item
    
    case bookList
    case wishList
}
