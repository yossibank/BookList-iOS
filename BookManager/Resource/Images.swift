import UIKit

struct ImageResources {

    struct App {
        static var noImage: UIImage = #imageLiteral(resourceName: "NoImage")
        static var check: UIImage = #imageLiteral(resourceName: "Check")
        static var nonCheck: UIImage = #imageLiteral(resourceName: "CheckBoxEmpty")
        static var favorite: UIImage = #imageLiteral(resourceName: "Favorite")
        static var nonFavorite: UIImage = #imageLiteral(resourceName: "FavoriteEmpty")
    }

    struct TabBar {
        static var bookList: UIImage = #imageLiteral(resourceName: "BookList")
        static var wishList: UIImage = #imageLiteral(resourceName: "Favorite")
        static var account: UIImage = #imageLiteral(resourceName: "Account")
    }

    struct Navigation {
        static var logout: UIImage = #imageLiteral(resourceName: "Logout")
        static var addUser: UIImage = #imageLiteral(resourceName: "AddUser")
    }
}
