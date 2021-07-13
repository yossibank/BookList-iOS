import Foundation
import Rswift
import UIKit

/// This `R` struct is generated and contains references to static resources.
struct R: Rswift.Validatable {
    fileprivate static let applicationLocale = hostingBundle.preferredLocalizations.first
        .flatMap { Locale(identifier: $0) } ?? Locale.current
    fileprivate static let hostingBundle = Bundle(for: R.Class.self)

    /// Find first language and bundle for which the table exists
    fileprivate static func localeBundle(
        tableName: String,
        preferredLanguages: [String]
    ) -> (Foundation.Locale, Foundation.Bundle)? {
        // Filter preferredLanguages to localizations, use first locale
        var languages = preferredLanguages
            .map { Locale(identifier: $0) }
            .prefix(1)
            .flatMap { locale -> [String] in
                if hostingBundle.localizations.contains(locale.identifier) {
                    if
                        let language = locale.languageCode,
                        hostingBundle.localizations.contains(language)
                    {
                        return [locale.identifier, language]
                    } else {
                        return [locale.identifier]
                    }
                } else if
                    let language = locale.languageCode,
                    hostingBundle.localizations.contains(language)
                {
                    return [language]
                } else {
                    return []
                }
            }

        // If there's no languages, use development language as backstop
        if languages.isEmpty {
            if let developmentLocalization = hostingBundle.developmentLocalization {
                languages = [developmentLocalization]
            }
        } else {
            // Insert Base as second item (between locale identifier and languageCode)
            languages.insert("Base", at: 1)

            // Add development language as backstop
            if let developmentLocalization = hostingBundle.developmentLocalization {
                languages.append(developmentLocalization)
            }
        }

        // Find first language for which table exists
        // Note: key might not exist in chosen language (in that case, key will be shown)
        for language in languages {
            if
                let lproj = hostingBundle.url(forResource: language, withExtension: "lproj"),
                let lbundle = Bundle(url: lproj)
            {
                let strings = lbundle.url(forResource: tableName, withExtension: "strings")
                let stringsdict = lbundle.url(forResource: tableName, withExtension: "stringsdict")

                if strings != nil || stringsdict != nil {
                    return (Locale(identifier: language), lbundle)
                }
            }
        }

        // If table is available in main bundle, don't look for localized resources
        let strings = hostingBundle.url(
            forResource: tableName,
            withExtension: "strings",
            subdirectory: nil,
            localization: nil
        )
        let stringsdict = hostingBundle.url(
            forResource: tableName,
            withExtension: "stringsdict",
            subdirectory: nil,
            localization: nil
        )

        if strings != nil || stringsdict != nil {
            return (applicationLocale, hostingBundle)
        }

        // If table is not found for requested languages, key will be shown
        return nil
    }

    /// Load string from Info.plist file
    fileprivate static func infoPlistString(path: [String], key: String) -> String? {
        var dict = hostingBundle.infoDictionary
        for step in path {
            guard let obj = dict?[step] as? [String: Any] else { return nil }
            dict = obj
        }
        return dict?[key] as? String
    }

    static func validate() throws {
        try intern.validate()
    }

    #if os(iOS) || os(tvOS)
    /// This `R.storyboard` struct is generated, and contains static references to 12 storyboards.
    struct storyboard {
        /// Storyboard `AddBookViewController`.
        static let addBookViewController = _R.storyboard.addBookViewController()
        /// Storyboard `BookListViewController`.
        static let bookListViewController = _R.storyboard.bookListViewController()
        /// Storyboard `ChatRoomViewController`.
        static let chatRoomViewController = _R.storyboard.chatRoomViewController()
        /// Storyboard `ChatSelectViewController`.
        static let chatSelectViewController = _R.storyboard.chatSelectViewController()
        /// Storyboard `ChatUserListViewController`.
        static let chatUserListViewController = _R.storyboard.chatUserListViewController()
        /// Storyboard `EditBookViewController`.
        static let editBookViewController = _R.storyboard.editBookViewController()
        /// Storyboard `HomeViewController`.
        static let homeViewController = _R.storyboard.homeViewController()
        /// Storyboard `LaunchScreen`.
        static let launchScreen = _R.storyboard.launchScreen()
        /// Storyboard `LoginViewController`.
        static let loginViewController = _R.storyboard.loginViewController()
        /// Storyboard `MainNavigationController`.
        static let mainNavigationController = _R.storyboard.mainNavigationController()
        /// Storyboard `SignupViewController`.
        static let signupViewController = _R.storyboard.signupViewController()
        /// Storyboard `WishListViewController`.
        static let wishListViewController = _R.storyboard.wishListViewController()

        #if os(iOS) || os(tvOS)
        /// `UIStoryboard(name: "AddBookViewController", bundle: ...)`
        static func addBookViewController(_: Void = ()) -> UIKit.UIStoryboard {
            UIKit.UIStoryboard(resource: R.storyboard.addBookViewController)
        }
        #endif

        #if os(iOS) || os(tvOS)
        /// `UIStoryboard(name: "BookListViewController", bundle: ...)`
        static func bookListViewController(_: Void = ()) -> UIKit.UIStoryboard {
            UIKit.UIStoryboard(resource: R.storyboard.bookListViewController)
        }
        #endif

        #if os(iOS) || os(tvOS)
        /// `UIStoryboard(name: "ChatRoomViewController", bundle: ...)`
        static func chatRoomViewController(_: Void = ()) -> UIKit.UIStoryboard {
            UIKit.UIStoryboard(resource: R.storyboard.chatRoomViewController)
        }
        #endif

        #if os(iOS) || os(tvOS)
        /// `UIStoryboard(name: "ChatSelectViewController", bundle: ...)`
        static func chatSelectViewController(_: Void = ()) -> UIKit.UIStoryboard {
            UIKit.UIStoryboard(resource: R.storyboard.chatSelectViewController)
        }
        #endif

        #if os(iOS) || os(tvOS)
        /// `UIStoryboard(name: "ChatUserListViewController", bundle: ...)`
        static func chatUserListViewController(_: Void = ()) -> UIKit.UIStoryboard {
            UIKit.UIStoryboard(resource: R.storyboard.chatUserListViewController)
        }
        #endif

        #if os(iOS) || os(tvOS)
        /// `UIStoryboard(name: "EditBookViewController", bundle: ...)`
        static func editBookViewController(_: Void = ()) -> UIKit.UIStoryboard {
            UIKit.UIStoryboard(resource: R.storyboard.editBookViewController)
        }
        #endif

        #if os(iOS) || os(tvOS)
        /// `UIStoryboard(name: "HomeViewController", bundle: ...)`
        static func homeViewController(_: Void = ()) -> UIKit.UIStoryboard {
            UIKit.UIStoryboard(resource: R.storyboard.homeViewController)
        }
        #endif

        #if os(iOS) || os(tvOS)
        /// `UIStoryboard(name: "LaunchScreen", bundle: ...)`
        static func launchScreen(_: Void = ()) -> UIKit.UIStoryboard {
            UIKit.UIStoryboard(resource: R.storyboard.launchScreen)
        }
        #endif

        #if os(iOS) || os(tvOS)
        /// `UIStoryboard(name: "LoginViewController", bundle: ...)`
        static func loginViewController(_: Void = ()) -> UIKit.UIStoryboard {
            UIKit.UIStoryboard(resource: R.storyboard.loginViewController)
        }
        #endif

        #if os(iOS) || os(tvOS)
        /// `UIStoryboard(name: "MainNavigationController", bundle: ...)`
        static func mainNavigationController(_: Void = ()) -> UIKit.UIStoryboard {
            UIKit.UIStoryboard(resource: R.storyboard.mainNavigationController)
        }
        #endif

        #if os(iOS) || os(tvOS)
        /// `UIStoryboard(name: "SignupViewController", bundle: ...)`
        static func signupViewController(_: Void = ()) -> UIKit.UIStoryboard {
            UIKit.UIStoryboard(resource: R.storyboard.signupViewController)
        }
        #endif

        #if os(iOS) || os(tvOS)
        /// `UIStoryboard(name: "WishListViewController", bundle: ...)`
        static func wishListViewController(_: Void = ()) -> UIKit.UIStoryboard {
            UIKit.UIStoryboard(resource: R.storyboard.wishListViewController)
        }
        #endif

        fileprivate init() {}
    }
    #endif

    /// This `R.color` struct is generated, and contains static references to 1 colors.
    struct color {
        /// Color `AccentColor`.
        static let accentColor = Rswift.ColorResource(bundle: R.hostingBundle, name: "AccentColor")

        #if os(iOS) || os(tvOS)
        /// `UIColor(named: "AccentColor", bundle: ..., traitCollection: ...)`
        @available(tvOS 11.0, *)
        @available(iOS 11.0, *)
        static func accentColor(
            compatibleWith traitCollection: UIKit
                .UITraitCollection? = nil
        ) -> UIKit
            .UIColor?
        {
            UIKit.UIColor(resource: R.color.accentColor, compatibleWith: traitCollection)
        }
        #endif

        #if os(watchOS)
        /// `UIColor(named: "AccentColor", bundle: ..., traitCollection: ...)`
        @available(watchOSApplicationExtension 4.0, *)
        static func accentColor(_: Void = ()) -> UIKit.UIColor? {
            UIKit.UIColor(named: R.color.accentColor.name)
        }
        #endif

        fileprivate init() {}
    }

    /// This `R.file` struct is generated, and contains static references to 1 files.
    struct file {
        /// Resource file `GoogleService-Info.plist`.
        static let googleServiceInfoPlist = Rswift.FileResource(
            bundle: R.hostingBundle,
            name: "GoogleService-Info",
            pathExtension: "plist"
        )

        /// `bundle.url(forResource: "GoogleService-Info", withExtension: "plist")`
        static func googleServiceInfoPlist(_: Void = ()) -> Foundation.URL? {
            let fileResource = R.file.googleServiceInfoPlist
            return fileResource.bundle.url(forResource: fileResource)
        }

        fileprivate init() {}
    }

    /// This `R.image` struct is generated, and contains static references to 21 images.
    struct image {
        /// Image `Add_book`.
        static let add_book = Rswift.ImageResource(bundle: R.hostingBundle, name: "Add_book")
        /// Image `Book_list`.
        static let book_list = Rswift.ImageResource(bundle: R.hostingBundle, name: "Book_list")
        /// Image `Chat`.
        static let chat = Rswift.ImageResource(bundle: R.hostingBundle, name: "Chat")
        /// Image `Check_In_Box`.
        static let check_In_Box = Rswift.ImageResource(
            bundle: R.hostingBundle,
            name: "Check_In_Box"
        )
        /// Image `Check_Off_Box`.
        static let check_Off_Box = Rswift.ImageResource(
            bundle: R.hostingBundle,
            name: "Check_Off_Box"
        )
        /// Image `Favorite`.
        static let favorite = Rswift.ImageResource(bundle: R.hostingBundle, name: "Favorite")
        /// Image `Launch_Image`.
        static let launch_Image = Rswift.ImageResource(
            bundle: R.hostingBundle,
            name: "Launch_Image"
        )
        /// Image `Logout`.
        static let logout = Rswift.ImageResource(bundle: R.hostingBundle, name: "Logout")
        /// Image `No_Image`.
        static let no_Image = Rswift.ImageResource(bundle: R.hostingBundle, name: "No_Image")
        /// Image `No_Selected_AddBook`.
        static let no_Selected_AddBook = Rswift.ImageResource(
            bundle: R.hostingBundle,
            name: "No_Selected_AddBook"
        )
        /// Image `No_Selected_BookList`.
        static let no_Selected_BookList = Rswift.ImageResource(
            bundle: R.hostingBundle,
            name: "No_Selected_BookList"
        )
        /// Image `No_Selected_Chat`.
        static let no_Selected_Chat = Rswift.ImageResource(
            bundle: R.hostingBundle,
            name: "No_Selected_Chat"
        )
        /// Image `No_Selected_Wishlist`.
        static let no_Selected_Wishlist = Rswift.ImageResource(
            bundle: R.hostingBundle,
            name: "No_Selected_Wishlist"
        )
        /// Image `No_favorite`.
        static let no_favorite = Rswift.ImageResource(bundle: R.hostingBundle, name: "No_favorite")
        /// Image `Selected_AddBook`.
        static let selected_AddBook = Rswift.ImageResource(
            bundle: R.hostingBundle,
            name: "Selected_AddBook"
        )
        /// Image `Selected_BookList`.
        static let selected_BookList = Rswift.ImageResource(
            bundle: R.hostingBundle,
            name: "Selected_BookList"
        )
        /// Image `Selected_Chat`.
        static let selected_Chat = Rswift.ImageResource(
            bundle: R.hostingBundle,
            name: "Selected_Chat"
        )
        /// Image `Selected_WishList`.
        static let selected_WishList = Rswift.ImageResource(
            bundle: R.hostingBundle,
            name: "Selected_WishList"
        )
        /// Image `Send`.
        static let send = Rswift.ImageResource(bundle: R.hostingBundle, name: "Send")
        /// Image `Wish_list`.
        static let wish_list = Rswift.ImageResource(bundle: R.hostingBundle, name: "Wish_list")
        /// Image `add_chat_user`.
        static let add_chat_user = Rswift.ImageResource(
            bundle: R.hostingBundle,
            name: "add_chat_user"
        )

        #if os(iOS) || os(tvOS)
        /// `UIImage(named: "Add_book", bundle: ..., traitCollection: ...)`
        static func add_book(
            compatibleWith traitCollection: UIKit
                .UITraitCollection? = nil
        ) -> UIKit
            .UIImage?
        {
            UIKit.UIImage(resource: R.image.add_book, compatibleWith: traitCollection)
        }
        #endif

        #if os(iOS) || os(tvOS)
        /// `UIImage(named: "Book_list", bundle: ..., traitCollection: ...)`
        static func book_list(
            compatibleWith traitCollection: UIKit
                .UITraitCollection? = nil
        ) -> UIKit
            .UIImage?
        {
            UIKit.UIImage(resource: R.image.book_list, compatibleWith: traitCollection)
        }
        #endif

        #if os(iOS) || os(tvOS)
        /// `UIImage(named: "Chat", bundle: ..., traitCollection: ...)`
        static func chat(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit
            .UIImage?
        {
            UIKit.UIImage(resource: R.image.chat, compatibleWith: traitCollection)
        }
        #endif

        #if os(iOS) || os(tvOS)
        /// `UIImage(named: "Check_In_Box", bundle: ..., traitCollection: ...)`
        static func check_In_Box(
            compatibleWith traitCollection: UIKit
                .UITraitCollection? = nil
        ) -> UIKit.UIImage? {
            UIKit.UIImage(resource: R.image.check_In_Box, compatibleWith: traitCollection)
        }
        #endif

        #if os(iOS) || os(tvOS)
        /// `UIImage(named: "Check_Off_Box", bundle: ..., traitCollection: ...)`
        static func check_Off_Box(
            compatibleWith traitCollection: UIKit
                .UITraitCollection? = nil
        ) -> UIKit.UIImage? {
            UIKit.UIImage(resource: R.image.check_Off_Box, compatibleWith: traitCollection)
        }
        #endif

        #if os(iOS) || os(tvOS)
        /// `UIImage(named: "Favorite", bundle: ..., traitCollection: ...)`
        static func favorite(
            compatibleWith traitCollection: UIKit
                .UITraitCollection? = nil
        ) -> UIKit
            .UIImage?
        {
            UIKit.UIImage(resource: R.image.favorite, compatibleWith: traitCollection)
        }
        #endif

        #if os(iOS) || os(tvOS)
        /// `UIImage(named: "Launch_Image", bundle: ..., traitCollection: ...)`
        static func launch_Image(
            compatibleWith traitCollection: UIKit
                .UITraitCollection? = nil
        ) -> UIKit.UIImage? {
            UIKit.UIImage(resource: R.image.launch_Image, compatibleWith: traitCollection)
        }
        #endif

        #if os(iOS) || os(tvOS)
        /// `UIImage(named: "Logout", bundle: ..., traitCollection: ...)`
        static func logout(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit
            .UIImage?
        {
            UIKit.UIImage(resource: R.image.logout, compatibleWith: traitCollection)
        }
        #endif

        #if os(iOS) || os(tvOS)
        /// `UIImage(named: "No_Image", bundle: ..., traitCollection: ...)`
        static func no_Image(
            compatibleWith traitCollection: UIKit
                .UITraitCollection? = nil
        ) -> UIKit
            .UIImage?
        {
            UIKit.UIImage(resource: R.image.no_Image, compatibleWith: traitCollection)
        }
        #endif

        #if os(iOS) || os(tvOS)
        /// `UIImage(named: "No_Selected_AddBook", bundle: ..., traitCollection: ...)`
        static func no_Selected_AddBook(
            compatibleWith traitCollection: UIKit
                .UITraitCollection? = nil
        ) -> UIKit.UIImage? {
            UIKit.UIImage(resource: R.image.no_Selected_AddBook, compatibleWith: traitCollection)
        }
        #endif

        #if os(iOS) || os(tvOS)
        /// `UIImage(named: "No_Selected_BookList", bundle: ..., traitCollection: ...)`
        static func no_Selected_BookList(
            compatibleWith traitCollection: UIKit
                .UITraitCollection? = nil
        ) -> UIKit.UIImage? {
            UIKit.UIImage(resource: R.image.no_Selected_BookList, compatibleWith: traitCollection)
        }
        #endif

        #if os(iOS) || os(tvOS)
        /// `UIImage(named: "No_Selected_Chat", bundle: ..., traitCollection: ...)`
        static func no_Selected_Chat(
            compatibleWith traitCollection: UIKit
                .UITraitCollection? = nil
        ) -> UIKit.UIImage? {
            UIKit.UIImage(resource: R.image.no_Selected_Chat, compatibleWith: traitCollection)
        }
        #endif

        #if os(iOS) || os(tvOS)
        /// `UIImage(named: "No_Selected_Wishlist", bundle: ..., traitCollection: ...)`
        static func no_Selected_Wishlist(
            compatibleWith traitCollection: UIKit
                .UITraitCollection? = nil
        ) -> UIKit.UIImage? {
            UIKit.UIImage(resource: R.image.no_Selected_Wishlist, compatibleWith: traitCollection)
        }
        #endif

        #if os(iOS) || os(tvOS)
        /// `UIImage(named: "No_favorite", bundle: ..., traitCollection: ...)`
        static func no_favorite(
            compatibleWith traitCollection: UIKit
                .UITraitCollection? = nil
        ) -> UIKit
            .UIImage?
        {
            UIKit.UIImage(resource: R.image.no_favorite, compatibleWith: traitCollection)
        }
        #endif

        #if os(iOS) || os(tvOS)
        /// `UIImage(named: "Selected_AddBook", bundle: ..., traitCollection: ...)`
        static func selected_AddBook(
            compatibleWith traitCollection: UIKit
                .UITraitCollection? = nil
        ) -> UIKit.UIImage? {
            UIKit.UIImage(resource: R.image.selected_AddBook, compatibleWith: traitCollection)
        }
        #endif

        #if os(iOS) || os(tvOS)
        /// `UIImage(named: "Selected_BookList", bundle: ..., traitCollection: ...)`
        static func selected_BookList(
            compatibleWith traitCollection: UIKit
                .UITraitCollection? = nil
        ) -> UIKit.UIImage? {
            UIKit.UIImage(resource: R.image.selected_BookList, compatibleWith: traitCollection)
        }
        #endif

        #if os(iOS) || os(tvOS)
        /// `UIImage(named: "Selected_Chat", bundle: ..., traitCollection: ...)`
        static func selected_Chat(
            compatibleWith traitCollection: UIKit
                .UITraitCollection? = nil
        ) -> UIKit.UIImage? {
            UIKit.UIImage(resource: R.image.selected_Chat, compatibleWith: traitCollection)
        }
        #endif

        #if os(iOS) || os(tvOS)
        /// `UIImage(named: "Selected_WishList", bundle: ..., traitCollection: ...)`
        static func selected_WishList(
            compatibleWith traitCollection: UIKit
                .UITraitCollection? = nil
        ) -> UIKit.UIImage? {
            UIKit.UIImage(resource: R.image.selected_WishList, compatibleWith: traitCollection)
        }
        #endif

        #if os(iOS) || os(tvOS)
        /// `UIImage(named: "Send", bundle: ..., traitCollection: ...)`
        static func send(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit
            .UIImage?
        {
            UIKit.UIImage(resource: R.image.send, compatibleWith: traitCollection)
        }
        #endif

        #if os(iOS) || os(tvOS)
        /// `UIImage(named: "Wish_list", bundle: ..., traitCollection: ...)`
        static func wish_list(
            compatibleWith traitCollection: UIKit
                .UITraitCollection? = nil
        ) -> UIKit
            .UIImage?
        {
            UIKit.UIImage(resource: R.image.wish_list, compatibleWith: traitCollection)
        }
        #endif

        #if os(iOS) || os(tvOS)
        /// `UIImage(named: "add_chat_user", bundle: ..., traitCollection: ...)`
        static func add_chat_user(
            compatibleWith traitCollection: UIKit
                .UITraitCollection? = nil
        ) -> UIKit.UIImage? {
            UIKit.UIImage(resource: R.image.add_chat_user, compatibleWith: traitCollection)
        }
        #endif

        fileprivate init() {}
    }

    /// This `R.nib` struct is generated, and contains static references to 8 nibs.
    struct nib {
        /// Nib `BookListTableViewCell`.
        static let bookListTableViewCell = _R.nib._BookListTableViewCell()
        /// Nib `ChatSelectTableViewCell`.
        static let chatSelectTableViewCell = _R.nib._ChatSelectTableViewCell()
        /// Nib `ChatUserListTableViewCell`.
        static let chatUserListTableViewCell = _R.nib._ChatUserListTableViewCell()
        /// Nib `HomeTableViewCell`.
        static let homeTableViewCell = _R.nib._HomeTableViewCell()
        /// Nib `KeyboardAccessoryView`.
        static let keyboardAccessoryView = _R.nib._KeyboardAccessoryView()
        /// Nib `MyMessageTableViewCell`.
        static let myMessageTableViewCell = _R.nib._MyMessageTableViewCell()
        /// Nib `OtherMessageTableViewCell`.
        static let otherMessageTableViewCell = _R.nib._OtherMessageTableViewCell()
        /// Nib `WishListTableViewCell`.
        static let wishListTableViewCell = _R.nib._WishListTableViewCell()

        #if os(iOS) || os(tvOS)
        /// `UINib(name: "BookListTableViewCell", in: bundle)`
        @available(
            *,
            deprecated,
            message: "Use UINib(resource: R.nib.bookListTableViewCell) instead"
        )
        static func bookListTableViewCell(_: Void = ()) -> UIKit.UINib {
            UIKit.UINib(resource: R.nib.bookListTableViewCell)
        }
        #endif

        #if os(iOS) || os(tvOS)
        /// `UINib(name: "ChatSelectTableViewCell", in: bundle)`
        @available(
            *,
            deprecated,
            message: "Use UINib(resource: R.nib.chatSelectTableViewCell) instead"
        )
        static func chatSelectTableViewCell(_: Void = ()) -> UIKit.UINib {
            UIKit.UINib(resource: R.nib.chatSelectTableViewCell)
        }
        #endif

        #if os(iOS) || os(tvOS)
        /// `UINib(name: "ChatUserListTableViewCell", in: bundle)`
        @available(
            *,
            deprecated,
            message: "Use UINib(resource: R.nib.chatUserListTableViewCell) instead"
        )
        static func chatUserListTableViewCell(_: Void = ()) -> UIKit.UINib {
            UIKit.UINib(resource: R.nib.chatUserListTableViewCell)
        }
        #endif

        #if os(iOS) || os(tvOS)
        /// `UINib(name: "HomeTableViewCell", in: bundle)`
        @available(*, deprecated, message: "Use UINib(resource: R.nib.homeTableViewCell) instead")
        static func homeTableViewCell(_: Void = ()) -> UIKit.UINib {
            UIKit.UINib(resource: R.nib.homeTableViewCell)
        }
        #endif

        #if os(iOS) || os(tvOS)
        /// `UINib(name: "KeyboardAccessoryView", in: bundle)`
        @available(
            *,
            deprecated,
            message: "Use UINib(resource: R.nib.keyboardAccessoryView) instead"
        )
        static func keyboardAccessoryView(_: Void = ()) -> UIKit.UINib {
            UIKit.UINib(resource: R.nib.keyboardAccessoryView)
        }
        #endif

        #if os(iOS) || os(tvOS)
        /// `UINib(name: "MyMessageTableViewCell", in: bundle)`
        @available(
            *,
            deprecated,
            message: "Use UINib(resource: R.nib.myMessageTableViewCell) instead"
        )
        static func myMessageTableViewCell(_: Void = ()) -> UIKit.UINib {
            UIKit.UINib(resource: R.nib.myMessageTableViewCell)
        }
        #endif

        #if os(iOS) || os(tvOS)
        /// `UINib(name: "OtherMessageTableViewCell", in: bundle)`
        @available(
            *,
            deprecated,
            message: "Use UINib(resource: R.nib.otherMessageTableViewCell) instead"
        )
        static func otherMessageTableViewCell(_: Void = ()) -> UIKit.UINib {
            UIKit.UINib(resource: R.nib.otherMessageTableViewCell)
        }
        #endif

        #if os(iOS) || os(tvOS)
        /// `UINib(name: "WishListTableViewCell", in: bundle)`
        @available(
            *,
            deprecated,
            message: "Use UINib(resource: R.nib.wishListTableViewCell) instead"
        )
        static func wishListTableViewCell(_: Void = ()) -> UIKit.UINib {
            UIKit.UINib(resource: R.nib.wishListTableViewCell)
        }
        #endif

        static func bookListTableViewCell(
            owner ownerOrNil: AnyObject?,
            options optionsOrNil: [UINib.OptionsKey : Any]? = nil
        ) -> BookListTableViewCell? {
            R.nib.bookListTableViewCell
                .instantiate(
                    withOwner: ownerOrNil,
                    options: optionsOrNil
                )[0] as? BookListTableViewCell
        }

        static func chatSelectTableViewCell(
            owner ownerOrNil: AnyObject?,
            options optionsOrNil: [UINib.OptionsKey : Any]? = nil
        ) -> ChatSelectTableViewCell? {
            R.nib.chatSelectTableViewCell
                .instantiate(
                    withOwner: ownerOrNil,
                    options: optionsOrNil
                )[0] as? ChatSelectTableViewCell
        }

        static func chatUserListTableViewCell(
            owner ownerOrNil: AnyObject?,
            options optionsOrNil: [UINib.OptionsKey : Any]? = nil
        ) -> ChatUserListTableViewCell? {
            R.nib.chatUserListTableViewCell
                .instantiate(
                    withOwner: ownerOrNil,
                    options: optionsOrNil
                )[0] as? ChatUserListTableViewCell
        }

        static func homeTableViewCell(
            owner ownerOrNil: AnyObject?,
            options optionsOrNil: [UINib.OptionsKey : Any]? = nil
        ) -> HomeTableViewCell? {
            R.nib.homeTableViewCell
                .instantiate(withOwner: ownerOrNil, options: optionsOrNil)[0] as? HomeTableViewCell
        }

        static func keyboardAccessoryView(
            owner ownerOrNil: AnyObject?,
            options optionsOrNil: [UINib.OptionsKey : Any]? = nil
        ) -> UIKit.UIView? {
            R.nib.keyboardAccessoryView
                .instantiate(withOwner: ownerOrNil, options: optionsOrNil)[0] as? UIKit.UIView
        }

        static func myMessageTableViewCell(
            owner ownerOrNil: AnyObject?,
            options optionsOrNil: [UINib.OptionsKey : Any]? = nil
        ) -> MyMessageTableViewCell? {
            R.nib.myMessageTableViewCell
                .instantiate(
                    withOwner: ownerOrNil,
                    options: optionsOrNil
                )[0] as? MyMessageTableViewCell
        }

        static func otherMessageTableViewCell(
            owner ownerOrNil: AnyObject?,
            options optionsOrNil: [UINib.OptionsKey : Any]? = nil
        ) -> OtherMessageTableViewCell? {
            R.nib.otherMessageTableViewCell
                .instantiate(
                    withOwner: ownerOrNil,
                    options: optionsOrNil
                )[0] as? OtherMessageTableViewCell
        }

        static func wishListTableViewCell(
            owner ownerOrNil: AnyObject?,
            options optionsOrNil: [UINib.OptionsKey : Any]? = nil
        ) -> WishListTableViewCell? {
            R.nib.wishListTableViewCell
                .instantiate(
                    withOwner: ownerOrNil,
                    options: optionsOrNil
                )[0] as? WishListTableViewCell
        }

        fileprivate init() {}
    }

    /// This `R.string` struct is generated, and contains static references to 1 localization tables.
    struct string {
        /// This `R.string.localizable` struct is generated, and contains static references to 45 localization keys.
        struct localizable {
            /// Value: %@が入力されていません
            static let not_filled = Rswift.StringResource(
                key: "not_filled",
                tableName: "Localizable",
                bundle: R.hostingBundle,
                locales: [],
                comment: nil
            )
            /// Value: +
            static let plus = Rswift.StringResource(
                key: "plus",
                tableName: "Localizable",
                bundle: R.hostingBundle,
                locales: [],
                comment: nil
            )
            /// Value: いいえ
            static let no = Rswift.StringResource(
                key: "no",
                tableName: "Localizable",
                bundle: R.hostingBundle,
                locales: [],
                comment: nil
            )
            /// Value: お気に入り書籍
            static let wish_list_book = Rswift.StringResource(
                key: "wish_list_book",
                tableName: "Localizable",
                bundle: R.hostingBundle,
                locales: [],
                comment: nil
            )
            /// Value: ご入力内容をもう一度ご確認ください
            static let please_check_again_contents = Rswift.StringResource(
                key: "please_check_again_contents",
                tableName: "Localizable",
                bundle: R.hostingBundle,
                locales: [],
                comment: nil
            )
            /// Value: はい
            static let yes = Rswift.StringResource(
                key: "yes",
                tableName: "Localizable",
                bundle: R.hostingBundle,
                locales: [],
                comment: nil
            )
            /// Value: エラー
            static let error = Rswift.StringResource(
                key: "error",
                tableName: "Localizable",
                bundle: R.hostingBundle,
                locales: [],
                comment: nil
            )
            /// Value: キャンセル
            static let cancel = Rswift.StringResource(
                key: "cancel",
                tableName: "Localizable",
                bundle: R.hostingBundle,
                locales: [],
                comment: nil
            )
            /// Value: タイトル
            static let title = Rswift.StringResource(
                key: "title",
                tableName: "Localizable",
                bundle: R.hostingBundle,
                locales: [],
                comment: nil
            )
            /// Value: タイトル名は%@文字以下でご入力ください
            static let not_longer_title_text = Rswift.StringResource(
                key: "not_longer_title_text",
                tableName: "Localizable",
                bundle: R.hostingBundle,
                locales: [],
                comment: nil
            )
            /// Value: チャット
            static let chat = Rswift.StringResource(
                key: "chat",
                tableName: "Localizable",
                bundle: R.hostingBundle,
                locales: [],
                comment: nil
            )
            /// Value: トーク一覧
            static let talk_list = Rswift.StringResource(
                key: "talk_list",
                tableName: "Localizable",
                bundle: R.hostingBundle,
                locales: [],
                comment: nil
            )
            /// Value: トーク開始
            static let start_talk = Rswift.StringResource(
                key: "start_talk",
                tableName: "Localizable",
                bundle: R.hostingBundle,
                locales: [],
                comment: nil
            )
            /// Value: ニックネーム
            static let nick_name = Rswift.StringResource(
                key: "nick_name",
                tableName: "Localizable",
                bundle: R.hostingBundle,
                locales: [],
                comment: nil
            )
            /// Value: パスワード
            static let password = Rswift.StringResource(
                key: "password",
                tableName: "Localizable",
                bundle: R.hostingBundle,
                locales: [],
                comment: nil
            )
            /// Value: パスワードとパスワード（確認）が一致しません
            static let not_matching_password = Rswift.StringResource(
                key: "not_matching_password",
                tableName: "Localizable",
                bundle: R.hostingBundle,
                locales: [],
                comment: nil
            )
            /// Value: パスワードは%@文字以上で入力が必要です
            static let not_length_password = Rswift.StringResource(
                key: "not_length_password",
                tableName: "Localizable",
                bundle: R.hostingBundle,
                locales: [],
                comment: nil
            )
            /// Value: ホーム
            static let home = Rswift.StringResource(
                key: "home",
                tableName: "Localizable",
                bundle: R.hostingBundle,
                locales: [],
                comment: nil
            )
            /// Value: メールアドレス
            static let mail_address = Rswift.StringResource(
                key: "mail_address",
                tableName: "Localizable",
                bundle: R.hostingBundle,
                locales: [],
                comment: nil
            )
            /// Value: メールアドレスが使用されている可能性があります
            static let maybe_already_email = Rswift.StringResource(
                key: "maybe_already_email",
                tableName: "Localizable",
                bundle: R.hostingBundle,
                locales: [],
                comment: nil
            )
            /// Value: メールアドレスが正しいフォームで入力されていません
            static let not_correct_format_email = Rswift.StringResource(
                key: "not_correct_format_email",
                tableName: "Localizable",
                bundle: R.hostingBundle,
                locales: [],
                comment: nil
            )
            /// Value: ユーザー選択
            static let select_user = Rswift.StringResource(
                key: "select_user",
                tableName: "Localizable",
                bundle: R.hostingBundle,
                locales: [],
                comment: nil
            )
            /// Value: ログアウト
            static let logout = Rswift.StringResource(
                key: "logout",
                tableName: "Localizable",
                bundle: R.hostingBundle,
                locales: [],
                comment: nil
            )
            /// Value: ログアウトしますか？
            static let did_you_logout = Rswift.StringResource(
                key: "did_you_logout",
                tableName: "Localizable",
                bundle: R.hostingBundle,
                locales: [],
                comment: nil
            )
            /// Value: ログアウトに失敗しました
            static let failed_logout = Rswift.StringResource(
                key: "failed_logout",
                tableName: "Localizable",
                bundle: R.hostingBundle,
                locales: [],
                comment: nil
            )
            /// Value: ログインに失敗しました
            static let failed_login = Rswift.StringResource(
                key: "failed_login",
                tableName: "Localizable",
                bundle: R.hostingBundle,
                locales: [],
                comment: nil
            )
            /// Value: 円
            static let yen = Rswift.StringResource(
                key: "yen",
                tableName: "Localizable",
                bundle: R.hostingBundle,
                locales: [],
                comment: nil
            )
            /// Value: 失敗
            static let failure = Rswift.StringResource(
                key: "failure",
                tableName: "Localizable",
                bundle: R.hostingBundle,
                locales: [],
                comment: nil
            )
            /// Value: 完了
            static let done = Rswift.StringResource(
                key: "done",
                tableName: "Localizable",
                bundle: R.hostingBundle,
                locales: [],
                comment: nil
            )
            /// Value: 成功
            static let success = Rswift.StringResource(
                key: "success",
                tableName: "Localizable",
                bundle: R.hostingBundle,
                locales: [],
                comment: nil
            )
            /// Value: 数字のみご入力ください
            static let only_input_number = Rswift.StringResource(
                key: "only_input_number",
                tableName: "Localizable",
                bundle: R.hostingBundle,
                locales: [],
                comment: nil
            )
            /// Value: 書籍の取得に失敗しました
            static let failed_book_list = Rswift.StringResource(
                key: "failed_book_list",
                tableName: "Localizable",
                bundle: R.hostingBundle,
                locales: [],
                comment: nil
            )
            /// Value: 書籍一覧
            static let book_list = Rswift.StringResource(
                key: "book_list",
                tableName: "Localizable",
                bundle: R.hostingBundle,
                locales: [],
                comment: nil
            )
            /// Value: 書籍登録が完了しました
            static let success_add_book = Rswift.StringResource(
                key: "success_add_book",
                tableName: "Localizable",
                bundle: R.hostingBundle,
                locales: [],
                comment: nil
            )
            /// Value: 書籍登録に失敗しました
            static let failed_add_book = Rswift.StringResource(
                key: "failed_add_book",
                tableName: "Localizable",
                bundle: R.hostingBundle,
                locales: [],
                comment: nil
            )
            /// Value: 書籍編集
            static let edit_book = Rswift.StringResource(
                key: "edit_book",
                tableName: "Localizable",
                bundle: R.hostingBundle,
                locales: [],
                comment: nil
            )
            /// Value: 書籍編集が完了しました
            static let success_edit_book = Rswift.StringResource(
                key: "success_edit_book",
                tableName: "Localizable",
                bundle: R.hostingBundle,
                locales: [],
                comment: nil
            )
            /// Value: 書籍編集に失敗しました
            static let failed_edit_book = Rswift.StringResource(
                key: "failed_edit_book",
                tableName: "Localizable",
                bundle: R.hostingBundle,
                locales: [],
                comment: nil
            )
            /// Value: 書籍追加
            static let add_book = Rswift.StringResource(
                key: "add_book",
                tableName: "Localizable",
                bundle: R.hostingBundle,
                locales: [],
                comment: nil
            )
            /// Value: 登録に失敗しました
            static let failed_signup = Rswift.StringResource(
                key: "failed_signup",
                tableName: "Localizable",
                bundle: R.hostingBundle,
                locales: [],
                comment: nil
            )
            /// Value: 税
            static let tax = Rswift.StringResource(
                key: "tax",
                tableName: "Localizable",
                bundle: R.hostingBundle,
                locales: [],
                comment: nil
            )
            /// Value: 購入日
            static let purchase_date = Rswift.StringResource(
                key: "purchase_date",
                tableName: "Localizable",
                bundle: R.hostingBundle,
                locales: [],
                comment: nil
            )
            /// Value: 追加
            static let add = Rswift.StringResource(
                key: "add",
                tableName: "Localizable",
                bundle: R.hostingBundle,
                locales: [],
                comment: nil
            )
            /// Value: 金額
            static let price = Rswift.StringResource(
                key: "price",
                tableName: "Localizable",
                bundle: R.hostingBundle,
                locales: [],
                comment: nil
            )
            /// Value: 閉じる
            static let close = Rswift.StringResource(
                key: "close",
                tableName: "Localizable",
                bundle: R.hostingBundle,
                locales: [],
                comment: nil
            )

            /// Value: %@が入力されていません
            static func not_filled(
                _ value1: String,
                preferredLanguages: [String]? = nil
            ) -> String {
                guard let preferredLanguages = preferredLanguages else {
                    let format = NSLocalizedString("not_filled", bundle: hostingBundle, comment: "")
                    return String(format: format, locale: applicationLocale, value1)
                }

                guard
                    let (locale, bundle) = localeBundle(
                        tableName: "Localizable",
                        preferredLanguages: preferredLanguages
                    )
                else {
                    return "not_filled"
                }

                let format = NSLocalizedString("not_filled", bundle: bundle, comment: "")
                return String(format: format, locale: locale, value1)
            }

            /// Value: +
            static func plus(preferredLanguages: [String]? = nil) -> String {
                guard let preferredLanguages = preferredLanguages else {
                    return NSLocalizedString("plus", bundle: hostingBundle, comment: "")
                }

                guard
                    let (_, bundle) = localeBundle(
                        tableName: "Localizable",
                        preferredLanguages: preferredLanguages
                    )
                else {
                    return "plus"
                }

                return NSLocalizedString("plus", bundle: bundle, comment: "")
            }

            /// Value: いいえ
            static func no(preferredLanguages: [String]? = nil) -> String {
                guard let preferredLanguages = preferredLanguages else {
                    return NSLocalizedString("no", bundle: hostingBundle, comment: "")
                }

                guard
                    let (_, bundle) = localeBundle(
                        tableName: "Localizable",
                        preferredLanguages: preferredLanguages
                    )
                else {
                    return "no"
                }

                return NSLocalizedString("no", bundle: bundle, comment: "")
            }

            /// Value: お気に入り書籍
            static func wish_list_book(preferredLanguages: [String]? = nil) -> String {
                guard let preferredLanguages = preferredLanguages else {
                    return NSLocalizedString("wish_list_book", bundle: hostingBundle, comment: "")
                }

                guard
                    let (_, bundle) = localeBundle(
                        tableName: "Localizable",
                        preferredLanguages: preferredLanguages
                    )
                else {
                    return "wish_list_book"
                }

                return NSLocalizedString("wish_list_book", bundle: bundle, comment: "")
            }

            /// Value: ご入力内容をもう一度ご確認ください
            static func please_check_again_contents(preferredLanguages: [String]? = nil) -> String {
                guard let preferredLanguages = preferredLanguages else {
                    return NSLocalizedString(
                        "please_check_again_contents",
                        bundle: hostingBundle,
                        comment: ""
                    )
                }

                guard
                    let (_, bundle) = localeBundle(
                        tableName: "Localizable",
                        preferredLanguages: preferredLanguages
                    )
                else {
                    return "please_check_again_contents"
                }

                return NSLocalizedString("please_check_again_contents", bundle: bundle, comment: "")
            }

            /// Value: はい
            static func yes(preferredLanguages: [String]? = nil) -> String {
                guard let preferredLanguages = preferredLanguages else {
                    return NSLocalizedString("yes", bundle: hostingBundle, comment: "")
                }

                guard
                    let (_, bundle) = localeBundle(
                        tableName: "Localizable",
                        preferredLanguages: preferredLanguages
                    )
                else {
                    return "yes"
                }

                return NSLocalizedString("yes", bundle: bundle, comment: "")
            }

            /// Value: エラー
            static func error(preferredLanguages: [String]? = nil) -> String {
                guard let preferredLanguages = preferredLanguages else {
                    return NSLocalizedString("error", bundle: hostingBundle, comment: "")
                }

                guard
                    let (_, bundle) = localeBundle(
                        tableName: "Localizable",
                        preferredLanguages: preferredLanguages
                    )
                else {
                    return "error"
                }

                return NSLocalizedString("error", bundle: bundle, comment: "")
            }

            /// Value: キャンセル
            static func cancel(preferredLanguages: [String]? = nil) -> String {
                guard let preferredLanguages = preferredLanguages else {
                    return NSLocalizedString("cancel", bundle: hostingBundle, comment: "")
                }

                guard
                    let (_, bundle) = localeBundle(
                        tableName: "Localizable",
                        preferredLanguages: preferredLanguages
                    )
                else {
                    return "cancel"
                }

                return NSLocalizedString("cancel", bundle: bundle, comment: "")
            }

            /// Value: タイトル
            static func title(preferredLanguages: [String]? = nil) -> String {
                guard let preferredLanguages = preferredLanguages else {
                    return NSLocalizedString("title", bundle: hostingBundle, comment: "")
                }

                guard
                    let (_, bundle) = localeBundle(
                        tableName: "Localizable",
                        preferredLanguages: preferredLanguages
                    )
                else {
                    return "title"
                }

                return NSLocalizedString("title", bundle: bundle, comment: "")
            }

            /// Value: タイトル名は%@文字以下でご入力ください
            static func not_longer_title_text(
                _ value1: String,
                preferredLanguages: [String]? = nil
            ) -> String {
                guard let preferredLanguages = preferredLanguages else {
                    let format = NSLocalizedString(
                        "not_longer_title_text",
                        bundle: hostingBundle,
                        comment: ""
                    )
                    return String(format: format, locale: applicationLocale, value1)
                }

                guard
                    let (locale, bundle) = localeBundle(
                        tableName: "Localizable",
                        preferredLanguages: preferredLanguages
                    )
                else {
                    return "not_longer_title_text"
                }

                let format = NSLocalizedString("not_longer_title_text", bundle: bundle, comment: "")
                return String(format: format, locale: locale, value1)
            }

            /// Value: チャット
            static func chat(preferredLanguages: [String]? = nil) -> String {
                guard let preferredLanguages = preferredLanguages else {
                    return NSLocalizedString("chat", bundle: hostingBundle, comment: "")
                }

                guard
                    let (_, bundle) = localeBundle(
                        tableName: "Localizable",
                        preferredLanguages: preferredLanguages
                    )
                else {
                    return "chat"
                }

                return NSLocalizedString("chat", bundle: bundle, comment: "")
            }

            /// Value: トーク一覧
            static func talk_list(preferredLanguages: [String]? = nil) -> String {
                guard let preferredLanguages = preferredLanguages else {
                    return NSLocalizedString("talk_list", bundle: hostingBundle, comment: "")
                }

                guard
                    let (_, bundle) = localeBundle(
                        tableName: "Localizable",
                        preferredLanguages: preferredLanguages
                    )
                else {
                    return "talk_list"
                }

                return NSLocalizedString("talk_list", bundle: bundle, comment: "")
            }

            /// Value: トーク開始
            static func start_talk(preferredLanguages: [String]? = nil) -> String {
                guard let preferredLanguages = preferredLanguages else {
                    return NSLocalizedString("start_talk", bundle: hostingBundle, comment: "")
                }

                guard
                    let (_, bundle) = localeBundle(
                        tableName: "Localizable",
                        preferredLanguages: preferredLanguages
                    )
                else {
                    return "start_talk"
                }

                return NSLocalizedString("start_talk", bundle: bundle, comment: "")
            }

            /// Value: ニックネーム
            static func nick_name(preferredLanguages: [String]? = nil) -> String {
                guard let preferredLanguages = preferredLanguages else {
                    return NSLocalizedString("nick_name", bundle: hostingBundle, comment: "")
                }

                guard
                    let (_, bundle) = localeBundle(
                        tableName: "Localizable",
                        preferredLanguages: preferredLanguages
                    )
                else {
                    return "nick_name"
                }

                return NSLocalizedString("nick_name", bundle: bundle, comment: "")
            }

            /// Value: パスワード
            static func password(preferredLanguages: [String]? = nil) -> String {
                guard let preferredLanguages = preferredLanguages else {
                    return NSLocalizedString("password", bundle: hostingBundle, comment: "")
                }

                guard
                    let (_, bundle) = localeBundle(
                        tableName: "Localizable",
                        preferredLanguages: preferredLanguages
                    )
                else {
                    return "password"
                }

                return NSLocalizedString("password", bundle: bundle, comment: "")
            }

            /// Value: パスワードとパスワード（確認）が一致しません
            static func not_matching_password(preferredLanguages: [String]? = nil) -> String {
                guard let preferredLanguages = preferredLanguages else {
                    return NSLocalizedString(
                        "not_matching_password",
                        bundle: hostingBundle,
                        comment: ""
                    )
                }

                guard
                    let (_, bundle) = localeBundle(
                        tableName: "Localizable",
                        preferredLanguages: preferredLanguages
                    )
                else {
                    return "not_matching_password"
                }

                return NSLocalizedString("not_matching_password", bundle: bundle, comment: "")
            }

            /// Value: パスワードは%@文字以上で入力が必要です
            static func not_length_password(
                _ value1: String,
                preferredLanguages: [String]? = nil
            ) -> String {
                guard let preferredLanguages = preferredLanguages else {
                    let format = NSLocalizedString(
                        "not_length_password",
                        bundle: hostingBundle,
                        comment: ""
                    )
                    return String(format: format, locale: applicationLocale, value1)
                }

                guard
                    let (locale, bundle) = localeBundle(
                        tableName: "Localizable",
                        preferredLanguages: preferredLanguages
                    )
                else {
                    return "not_length_password"
                }

                let format = NSLocalizedString("not_length_password", bundle: bundle, comment: "")
                return String(format: format, locale: locale, value1)
            }

            /// Value: ホーム
            static func home(preferredLanguages: [String]? = nil) -> String {
                guard let preferredLanguages = preferredLanguages else {
                    return NSLocalizedString("home", bundle: hostingBundle, comment: "")
                }

                guard
                    let (_, bundle) = localeBundle(
                        tableName: "Localizable",
                        preferredLanguages: preferredLanguages
                    )
                else {
                    return "home"
                }

                return NSLocalizedString("home", bundle: bundle, comment: "")
            }

            /// Value: メールアドレス
            static func mail_address(preferredLanguages: [String]? = nil) -> String {
                guard let preferredLanguages = preferredLanguages else {
                    return NSLocalizedString("mail_address", bundle: hostingBundle, comment: "")
                }

                guard
                    let (_, bundle) = localeBundle(
                        tableName: "Localizable",
                        preferredLanguages: preferredLanguages
                    )
                else {
                    return "mail_address"
                }

                return NSLocalizedString("mail_address", bundle: bundle, comment: "")
            }

            /// Value: メールアドレスが使用されている可能性があります
            static func maybe_already_email(preferredLanguages: [String]? = nil) -> String {
                guard let preferredLanguages = preferredLanguages else {
                    return NSLocalizedString(
                        "maybe_already_email",
                        bundle: hostingBundle,
                        comment: ""
                    )
                }

                guard
                    let (_, bundle) = localeBundle(
                        tableName: "Localizable",
                        preferredLanguages: preferredLanguages
                    )
                else {
                    return "maybe_already_email"
                }

                return NSLocalizedString("maybe_already_email", bundle: bundle, comment: "")
            }

            /// Value: メールアドレスが正しいフォームで入力されていません
            static func not_correct_format_email(preferredLanguages: [String]? = nil) -> String {
                guard let preferredLanguages = preferredLanguages else {
                    return NSLocalizedString(
                        "not_correct_format_email",
                        bundle: hostingBundle,
                        comment: ""
                    )
                }

                guard
                    let (_, bundle) = localeBundle(
                        tableName: "Localizable",
                        preferredLanguages: preferredLanguages
                    )
                else {
                    return "not_correct_format_email"
                }

                return NSLocalizedString("not_correct_format_email", bundle: bundle, comment: "")
            }

            /// Value: ユーザー選択
            static func select_user(preferredLanguages: [String]? = nil) -> String {
                guard let preferredLanguages = preferredLanguages else {
                    return NSLocalizedString("select_user", bundle: hostingBundle, comment: "")
                }

                guard
                    let (_, bundle) = localeBundle(
                        tableName: "Localizable",
                        preferredLanguages: preferredLanguages
                    )
                else {
                    return "select_user"
                }

                return NSLocalizedString("select_user", bundle: bundle, comment: "")
            }

            /// Value: ログアウト
            static func logout(preferredLanguages: [String]? = nil) -> String {
                guard let preferredLanguages = preferredLanguages else {
                    return NSLocalizedString("logout", bundle: hostingBundle, comment: "")
                }

                guard
                    let (_, bundle) = localeBundle(
                        tableName: "Localizable",
                        preferredLanguages: preferredLanguages
                    )
                else {
                    return "logout"
                }

                return NSLocalizedString("logout", bundle: bundle, comment: "")
            }

            /// Value: ログアウトしますか？
            static func did_you_logout(preferredLanguages: [String]? = nil) -> String {
                guard let preferredLanguages = preferredLanguages else {
                    return NSLocalizedString("did_you_logout", bundle: hostingBundle, comment: "")
                }

                guard
                    let (_, bundle) = localeBundle(
                        tableName: "Localizable",
                        preferredLanguages: preferredLanguages
                    )
                else {
                    return "did_you_logout"
                }

                return NSLocalizedString("did_you_logout", bundle: bundle, comment: "")
            }

            /// Value: ログアウトに失敗しました
            static func failed_logout(preferredLanguages: [String]? = nil) -> String {
                guard let preferredLanguages = preferredLanguages else {
                    return NSLocalizedString("failed_logout", bundle: hostingBundle, comment: "")
                }

                guard
                    let (_, bundle) = localeBundle(
                        tableName: "Localizable",
                        preferredLanguages: preferredLanguages
                    )
                else {
                    return "failed_logout"
                }

                return NSLocalizedString("failed_logout", bundle: bundle, comment: "")
            }

            /// Value: ログインに失敗しました
            static func failed_login(preferredLanguages: [String]? = nil) -> String {
                guard let preferredLanguages = preferredLanguages else {
                    return NSLocalizedString("failed_login", bundle: hostingBundle, comment: "")
                }

                guard
                    let (_, bundle) = localeBundle(
                        tableName: "Localizable",
                        preferredLanguages: preferredLanguages
                    )
                else {
                    return "failed_login"
                }

                return NSLocalizedString("failed_login", bundle: bundle, comment: "")
            }

            /// Value: 円
            static func yen(preferredLanguages: [String]? = nil) -> String {
                guard let preferredLanguages = preferredLanguages else {
                    return NSLocalizedString("yen", bundle: hostingBundle, comment: "")
                }

                guard
                    let (_, bundle) = localeBundle(
                        tableName: "Localizable",
                        preferredLanguages: preferredLanguages
                    )
                else {
                    return "yen"
                }

                return NSLocalizedString("yen", bundle: bundle, comment: "")
            }

            /// Value: 失敗
            static func failure(preferredLanguages: [String]? = nil) -> String {
                guard let preferredLanguages = preferredLanguages else {
                    return NSLocalizedString("failure", bundle: hostingBundle, comment: "")
                }

                guard
                    let (_, bundle) = localeBundle(
                        tableName: "Localizable",
                        preferredLanguages: preferredLanguages
                    )
                else {
                    return "failure"
                }

                return NSLocalizedString("failure", bundle: bundle, comment: "")
            }

            /// Value: 完了
            static func done(preferredLanguages: [String]? = nil) -> String {
                guard let preferredLanguages = preferredLanguages else {
                    return NSLocalizedString("done", bundle: hostingBundle, comment: "")
                }

                guard
                    let (_, bundle) = localeBundle(
                        tableName: "Localizable",
                        preferredLanguages: preferredLanguages
                    )
                else {
                    return "done"
                }

                return NSLocalizedString("done", bundle: bundle, comment: "")
            }

            /// Value: 成功
            static func success(preferredLanguages: [String]? = nil) -> String {
                guard let preferredLanguages = preferredLanguages else {
                    return NSLocalizedString("success", bundle: hostingBundle, comment: "")
                }

                guard
                    let (_, bundle) = localeBundle(
                        tableName: "Localizable",
                        preferredLanguages: preferredLanguages
                    )
                else {
                    return "success"
                }

                return NSLocalizedString("success", bundle: bundle, comment: "")
            }

            /// Value: 数字のみご入力ください
            static func only_input_number(preferredLanguages: [String]? = nil) -> String {
                guard let preferredLanguages = preferredLanguages else {
                    return NSLocalizedString(
                        "only_input_number",
                        bundle: hostingBundle,
                        comment: ""
                    )
                }

                guard
                    let (_, bundle) = localeBundle(
                        tableName: "Localizable",
                        preferredLanguages: preferredLanguages
                    )
                else {
                    return "only_input_number"
                }

                return NSLocalizedString("only_input_number", bundle: bundle, comment: "")
            }

            /// Value: 書籍の取得に失敗しました
            static func failed_book_list(preferredLanguages: [String]? = nil) -> String {
                guard let preferredLanguages = preferredLanguages else {
                    return NSLocalizedString("failed_book_list", bundle: hostingBundle, comment: "")
                }

                guard
                    let (_, bundle) = localeBundle(
                        tableName: "Localizable",
                        preferredLanguages: preferredLanguages
                    )
                else {
                    return "failed_book_list"
                }

                return NSLocalizedString("failed_book_list", bundle: bundle, comment: "")
            }

            /// Value: 書籍一覧
            static func book_list(preferredLanguages: [String]? = nil) -> String {
                guard let preferredLanguages = preferredLanguages else {
                    return NSLocalizedString("book_list", bundle: hostingBundle, comment: "")
                }

                guard
                    let (_, bundle) = localeBundle(
                        tableName: "Localizable",
                        preferredLanguages: preferredLanguages
                    )
                else {
                    return "book_list"
                }

                return NSLocalizedString("book_list", bundle: bundle, comment: "")
            }

            /// Value: 書籍登録が完了しました
            static func success_add_book(preferredLanguages: [String]? = nil) -> String {
                guard let preferredLanguages = preferredLanguages else {
                    return NSLocalizedString("success_add_book", bundle: hostingBundle, comment: "")
                }

                guard
                    let (_, bundle) = localeBundle(
                        tableName: "Localizable",
                        preferredLanguages: preferredLanguages
                    )
                else {
                    return "success_add_book"
                }

                return NSLocalizedString("success_add_book", bundle: bundle, comment: "")
            }

            /// Value: 書籍登録に失敗しました
            static func failed_add_book(preferredLanguages: [String]? = nil) -> String {
                guard let preferredLanguages = preferredLanguages else {
                    return NSLocalizedString("failed_add_book", bundle: hostingBundle, comment: "")
                }

                guard
                    let (_, bundle) = localeBundle(
                        tableName: "Localizable",
                        preferredLanguages: preferredLanguages
                    )
                else {
                    return "failed_add_book"
                }

                return NSLocalizedString("failed_add_book", bundle: bundle, comment: "")
            }

            /// Value: 書籍編集
            static func edit_book(preferredLanguages: [String]? = nil) -> String {
                guard let preferredLanguages = preferredLanguages else {
                    return NSLocalizedString("edit_book", bundle: hostingBundle, comment: "")
                }

                guard
                    let (_, bundle) = localeBundle(
                        tableName: "Localizable",
                        preferredLanguages: preferredLanguages
                    )
                else {
                    return "edit_book"
                }

                return NSLocalizedString("edit_book", bundle: bundle, comment: "")
            }

            /// Value: 書籍編集が完了しました
            static func success_edit_book(preferredLanguages: [String]? = nil) -> String {
                guard let preferredLanguages = preferredLanguages else {
                    return NSLocalizedString(
                        "success_edit_book",
                        bundle: hostingBundle,
                        comment: ""
                    )
                }

                guard
                    let (_, bundle) = localeBundle(
                        tableName: "Localizable",
                        preferredLanguages: preferredLanguages
                    )
                else {
                    return "success_edit_book"
                }

                return NSLocalizedString("success_edit_book", bundle: bundle, comment: "")
            }

            /// Value: 書籍編集に失敗しました
            static func failed_edit_book(preferredLanguages: [String]? = nil) -> String {
                guard let preferredLanguages = preferredLanguages else {
                    return NSLocalizedString("failed_edit_book", bundle: hostingBundle, comment: "")
                }

                guard
                    let (_, bundle) = localeBundle(
                        tableName: "Localizable",
                        preferredLanguages: preferredLanguages
                    )
                else {
                    return "failed_edit_book"
                }

                return NSLocalizedString("failed_edit_book", bundle: bundle, comment: "")
            }

            /// Value: 書籍追加
            static func add_book(preferredLanguages: [String]? = nil) -> String {
                guard let preferredLanguages = preferredLanguages else {
                    return NSLocalizedString("add_book", bundle: hostingBundle, comment: "")
                }

                guard
                    let (_, bundle) = localeBundle(
                        tableName: "Localizable",
                        preferredLanguages: preferredLanguages
                    )
                else {
                    return "add_book"
                }

                return NSLocalizedString("add_book", bundle: bundle, comment: "")
            }

            /// Value: 登録に失敗しました
            static func failed_signup(preferredLanguages: [String]? = nil) -> String {
                guard let preferredLanguages = preferredLanguages else {
                    return NSLocalizedString("failed_signup", bundle: hostingBundle, comment: "")
                }

                guard
                    let (_, bundle) = localeBundle(
                        tableName: "Localizable",
                        preferredLanguages: preferredLanguages
                    )
                else {
                    return "failed_signup"
                }

                return NSLocalizedString("failed_signup", bundle: bundle, comment: "")
            }

            /// Value: 税
            static func tax(preferredLanguages: [String]? = nil) -> String {
                guard let preferredLanguages = preferredLanguages else {
                    return NSLocalizedString("tax", bundle: hostingBundle, comment: "")
                }

                guard
                    let (_, bundle) = localeBundle(
                        tableName: "Localizable",
                        preferredLanguages: preferredLanguages
                    )
                else {
                    return "tax"
                }

                return NSLocalizedString("tax", bundle: bundle, comment: "")
            }

            /// Value: 購入日
            static func purchase_date(preferredLanguages: [String]? = nil) -> String {
                guard let preferredLanguages = preferredLanguages else {
                    return NSLocalizedString("purchase_date", bundle: hostingBundle, comment: "")
                }

                guard
                    let (_, bundle) = localeBundle(
                        tableName: "Localizable",
                        preferredLanguages: preferredLanguages
                    )
                else {
                    return "purchase_date"
                }

                return NSLocalizedString("purchase_date", bundle: bundle, comment: "")
            }

            /// Value: 追加
            static func add(preferredLanguages: [String]? = nil) -> String {
                guard let preferredLanguages = preferredLanguages else {
                    return NSLocalizedString("add", bundle: hostingBundle, comment: "")
                }

                guard
                    let (_, bundle) = localeBundle(
                        tableName: "Localizable",
                        preferredLanguages: preferredLanguages
                    )
                else {
                    return "add"
                }

                return NSLocalizedString("add", bundle: bundle, comment: "")
            }

            /// Value: 金額
            static func price(preferredLanguages: [String]? = nil) -> String {
                guard let preferredLanguages = preferredLanguages else {
                    return NSLocalizedString("price", bundle: hostingBundle, comment: "")
                }

                guard
                    let (_, bundle) = localeBundle(
                        tableName: "Localizable",
                        preferredLanguages: preferredLanguages
                    )
                else {
                    return "price"
                }

                return NSLocalizedString("price", bundle: bundle, comment: "")
            }

            /// Value: 閉じる
            static func close(preferredLanguages: [String]? = nil) -> String {
                guard let preferredLanguages = preferredLanguages else {
                    return NSLocalizedString("close", bundle: hostingBundle, comment: "")
                }

                guard
                    let (_, bundle) = localeBundle(
                        tableName: "Localizable",
                        preferredLanguages: preferredLanguages
                    )
                else {
                    return "close"
                }

                return NSLocalizedString("close", bundle: bundle, comment: "")
            }

            fileprivate init() {}
        }

        fileprivate init() {}
    }

    fileprivate struct intern: Rswift.Validatable {
        fileprivate static func validate() throws {
            try _R.validate()
        }

        fileprivate init() {}
    }

    fileprivate class Class {}

    fileprivate init() {}
}

struct _R: Rswift.Validatable {
    static func validate() throws {
        #if os(iOS) || os(tvOS)
        try nib.validate()
        #endif
        #if os(iOS) || os(tvOS)
        try storyboard.validate()
        #endif
    }

    #if os(iOS) || os(tvOS)
    struct nib: Rswift.Validatable {
        static func validate() throws {
            try _BookListTableViewCell.validate()
            try _KeyboardAccessoryView.validate()
        }

        struct _BookListTableViewCell: Rswift.NibResourceType, Rswift.Validatable {
            let bundle = R.hostingBundle
            let name = "BookListTableViewCell"

            func firstView(
                owner ownerOrNil: AnyObject?,
                options optionsOrNil: [UINib.OptionsKey : Any]? = nil
            ) -> BookListTableViewCell? {
                instantiate(
                    withOwner: ownerOrNil,
                    options: optionsOrNil
                )[0] as? BookListTableViewCell
            }

            static func validate() throws {
                if
                    UIKit
                        .UIImage(named: "No_favorite", in: R.hostingBundle, compatibleWith: nil) ==
                        nil
                {
                    throw Rswift
                        .ValidationError(
                            description: "[R.swift] Image named 'No_favorite' is used in nib 'BookListTableViewCell', but couldn't be loaded."
                        )
                }
                if #available(iOS 11.0, tvOS 11.0, *) {}
            }

            fileprivate init() {}
        }

        struct _ChatSelectTableViewCell: Rswift.NibResourceType {
            let bundle = R.hostingBundle
            let name = "ChatSelectTableViewCell"

            func firstView(
                owner ownerOrNil: AnyObject?,
                options optionsOrNil: [UINib.OptionsKey : Any]? = nil
            ) -> ChatSelectTableViewCell? {
                instantiate(
                    withOwner: ownerOrNil,
                    options: optionsOrNil
                )[0] as? ChatSelectTableViewCell
            }

            fileprivate init() {}
        }

        struct _ChatUserListTableViewCell: Rswift.NibResourceType {
            let bundle = R.hostingBundle
            let name = "ChatUserListTableViewCell"

            func firstView(
                owner ownerOrNil: AnyObject?,
                options optionsOrNil: [UINib.OptionsKey : Any]? = nil
            ) -> ChatUserListTableViewCell? {
                instantiate(
                    withOwner: ownerOrNil,
                    options: optionsOrNil
                )[0] as? ChatUserListTableViewCell
            }

            fileprivate init() {}
        }

        struct _HomeTableViewCell: Rswift.NibResourceType {
            let bundle = R.hostingBundle
            let name = "HomeTableViewCell"

            func firstView(
                owner ownerOrNil: AnyObject?,
                options optionsOrNil: [UINib.OptionsKey : Any]? = nil
            ) -> HomeTableViewCell? {
                instantiate(withOwner: ownerOrNil, options: optionsOrNil)[0] as? HomeTableViewCell
            }

            fileprivate init() {}
        }

        struct _KeyboardAccessoryView: Rswift.NibResourceType, Rswift.Validatable {
            let bundle = R.hostingBundle
            let name = "KeyboardAccessoryView"

            func firstView(
                owner ownerOrNil: AnyObject?,
                options optionsOrNil: [UINib.OptionsKey : Any]? = nil
            ) -> UIKit.UIView? {
                instantiate(withOwner: ownerOrNil, options: optionsOrNil)[0] as? UIKit.UIView
            }

            static func validate() throws {
                if
                    UIKit
                        .UIImage(named: "Send", in: R.hostingBundle, compatibleWith: nil) ==
                        nil
                {
                    throw Rswift
                        .ValidationError(
                            description: "[R.swift] Image named 'Send' is used in nib 'KeyboardAccessoryView', but couldn't be loaded."
                        )
                }
                if #available(iOS 11.0, tvOS 11.0, *) {}
            }

            fileprivate init() {}
        }

        struct _MyMessageTableViewCell: Rswift.NibResourceType {
            let bundle = R.hostingBundle
            let name = "MyMessageTableViewCell"

            func firstView(
                owner ownerOrNil: AnyObject?,
                options optionsOrNil: [UINib.OptionsKey : Any]? = nil
            ) -> MyMessageTableViewCell? {
                instantiate(
                    withOwner: ownerOrNil,
                    options: optionsOrNil
                )[0] as? MyMessageTableViewCell
            }

            fileprivate init() {}
        }

        struct _OtherMessageTableViewCell: Rswift.NibResourceType {
            let bundle = R.hostingBundle
            let name = "OtherMessageTableViewCell"

            func firstView(
                owner ownerOrNil: AnyObject?,
                options optionsOrNil: [UINib.OptionsKey : Any]? = nil
            ) -> OtherMessageTableViewCell? {
                instantiate(
                    withOwner: ownerOrNil,
                    options: optionsOrNil
                )[0] as? OtherMessageTableViewCell
            }

            fileprivate init() {}
        }

        struct _WishListTableViewCell: Rswift.NibResourceType {
            let bundle = R.hostingBundle
            let name = "WishListTableViewCell"

            func firstView(
                owner ownerOrNil: AnyObject?,
                options optionsOrNil: [UINib.OptionsKey : Any]? = nil
            ) -> WishListTableViewCell? {
                instantiate(
                    withOwner: ownerOrNil,
                    options: optionsOrNil
                )[0] as? WishListTableViewCell
            }

            fileprivate init() {}
        }

        fileprivate init() {}
    }
    #endif

    #if os(iOS) || os(tvOS)
    struct storyboard: Rswift.Validatable {
        static func validate() throws {
            #if os(iOS) || os(tvOS)
            try addBookViewController.validate()
            #endif
            #if os(iOS) || os(tvOS)
            try bookListViewController.validate()
            #endif
            #if os(iOS) || os(tvOS)
            try chatRoomViewController.validate()
            #endif
            #if os(iOS) || os(tvOS)
            try chatSelectViewController.validate()
            #endif
            #if os(iOS) || os(tvOS)
            try chatUserListViewController.validate()
            #endif
            #if os(iOS) || os(tvOS)
            try editBookViewController.validate()
            #endif
            #if os(iOS) || os(tvOS)
            try homeViewController.validate()
            #endif
            #if os(iOS) || os(tvOS)
            try launchScreen.validate()
            #endif
            #if os(iOS) || os(tvOS)
            try loginViewController.validate()
            #endif
            #if os(iOS) || os(tvOS)
            try mainNavigationController.validate()
            #endif
            #if os(iOS) || os(tvOS)
            try signupViewController.validate()
            #endif
            #if os(iOS) || os(tvOS)
            try wishListViewController.validate()
            #endif
        }

        #if os(iOS) || os(tvOS)
        struct addBookViewController: Rswift.StoryboardResourceWithInitialControllerType,
            Rswift.Validatable
        {
            typealias InitialController = AddBookViewController

            let bundle = R.hostingBundle
            let name = "AddBookViewController"

            static func validate() throws {
                if
                    UIKit
                        .UIImage(named: "No_Image", in: R.hostingBundle, compatibleWith: nil) ==
                        nil
                {
                    throw Rswift
                        .ValidationError(
                            description: "[R.swift] Image named 'No_Image' is used in storyboard 'AddBookViewController', but couldn't be loaded."
                        )
                }
                if #available(iOS 11.0, tvOS 11.0, *) {}
            }

            fileprivate init() {}
        }
        #endif

        #if os(iOS) || os(tvOS)
        struct bookListViewController: Rswift.StoryboardResourceWithInitialControllerType,
            Rswift.Validatable
        {
            typealias InitialController = BookListViewController

            let bundle = R.hostingBundle
            let name = "BookListViewController"

            static func validate() throws {
                if #available(iOS 11.0, tvOS 11.0, *) {}
            }

            fileprivate init() {}
        }
        #endif

        #if os(iOS) || os(tvOS)
        struct chatRoomViewController: Rswift.StoryboardResourceWithInitialControllerType,
            Rswift.Validatable
        {
            typealias InitialController = ChatRoomViewController

            let bundle = R.hostingBundle
            let name = "ChatRoomViewController"

            static func validate() throws {
                if #available(iOS 11.0, tvOS 11.0, *) {}
            }

            fileprivate init() {}
        }
        #endif

        #if os(iOS) || os(tvOS)
        struct chatSelectViewController: Rswift.StoryboardResourceWithInitialControllerType,
            Rswift.Validatable
        {
            typealias InitialController = ChatSelectViewController

            let bundle = R.hostingBundle
            let name = "ChatSelectViewController"

            static func validate() throws {
                if #available(iOS 11.0, tvOS 11.0, *) {}
            }

            fileprivate init() {}
        }
        #endif

        #if os(iOS) || os(tvOS)
        struct chatUserListViewController: Rswift.StoryboardResourceWithInitialControllerType,
            Rswift.Validatable
        {
            typealias InitialController = ChatUserListViewController

            let bundle = R.hostingBundle
            let name = "ChatUserListViewController"

            static func validate() throws {
                if #available(iOS 11.0, tvOS 11.0, *) {}
            }

            fileprivate init() {}
        }
        #endif

        #if os(iOS) || os(tvOS)
        struct editBookViewController: Rswift.StoryboardResourceWithInitialControllerType,
            Rswift.Validatable
        {
            typealias InitialController = EditBookViewController

            let bundle = R.hostingBundle
            let name = "EditBookViewController"

            static func validate() throws {
                if
                    UIKit
                        .UIImage(named: "No_Image", in: R.hostingBundle, compatibleWith: nil) ==
                        nil
                {
                    throw Rswift
                        .ValidationError(
                            description: "[R.swift] Image named 'No_Image' is used in storyboard 'EditBookViewController', but couldn't be loaded."
                        )
                }
                if #available(iOS 11.0, tvOS 11.0, *) {}
            }

            fileprivate init() {}
        }
        #endif

        #if os(iOS) || os(tvOS)
        struct homeViewController: Rswift.StoryboardResourceWithInitialControllerType,
            Rswift.Validatable
        {
            typealias InitialController = HomeViewController

            let bundle = R.hostingBundle
            let name = "HomeViewController"

            static func validate() throws {
                if #available(iOS 11.0, tvOS 11.0, *) {}
            }

            fileprivate init() {}
        }
        #endif

        #if os(iOS) || os(tvOS)
        struct launchScreen: Rswift.StoryboardResourceWithInitialControllerType,
            Rswift.Validatable
        {
            typealias InitialController = UIKit.UIViewController

            let bundle = R.hostingBundle
            let name = "LaunchScreen"

            static func validate() throws {
                if
                    UIKit
                        .UIImage(named: "Launch_Image", in: R.hostingBundle, compatibleWith: nil) ==
                        nil
                {
                    throw Rswift
                        .ValidationError(
                            description: "[R.swift] Image named 'Launch_Image' is used in storyboard 'LaunchScreen', but couldn't be loaded."
                        )
                }
                if #available(iOS 11.0, tvOS 11.0, *) {}
            }

            fileprivate init() {}
        }
        #endif

        #if os(iOS) || os(tvOS)
        struct loginViewController: Rswift.StoryboardResourceWithInitialControllerType,
            Rswift.Validatable
        {
            typealias InitialController = LoginViewController

            let bundle = R.hostingBundle
            let name = "LoginViewController"

            static func validate() throws {
                if
                    UIKit
                        .UIImage(
                            named: "Check_Off_Box",
                            in: R.hostingBundle,
                            compatibleWith: nil
                        ) ==
                        nil
                {
                    throw Rswift
                        .ValidationError(
                            description: "[R.swift] Image named 'Check_Off_Box' is used in storyboard 'LoginViewController', but couldn't be loaded."
                        )
                }
                if #available(iOS 11.0, tvOS 11.0, *) {}
            }

            fileprivate init() {}
        }
        #endif

        #if os(iOS) || os(tvOS)
        struct mainNavigationController: Rswift.StoryboardResourceWithInitialControllerType,
            Rswift.Validatable
        {
            typealias InitialController = MainNavigationController

            let bundle = R.hostingBundle
            let name = "MainNavigationController"

            static func validate() throws {
                if #available(iOS 11.0, tvOS 11.0, *) {}
            }

            fileprivate init() {}
        }
        #endif

        #if os(iOS) || os(tvOS)
        struct signupViewController: Rswift.StoryboardResourceWithInitialControllerType,
            Rswift.Validatable
        {
            typealias InitialController = SignupViewController

            let bundle = R.hostingBundle
            let name = "SignupViewController"

            static func validate() throws {
                if
                    UIKit
                        .UIImage(
                            named: "Check_Off_Box",
                            in: R.hostingBundle,
                            compatibleWith: nil
                        ) ==
                        nil
                {
                    throw Rswift
                        .ValidationError(
                            description: "[R.swift] Image named 'Check_Off_Box' is used in storyboard 'SignupViewController', but couldn't be loaded."
                        )
                }
                if
                    UIKit
                        .UIImage(named: "No_Image", in: R.hostingBundle, compatibleWith: nil) ==
                        nil
                {
                    throw Rswift
                        .ValidationError(
                            description: "[R.swift] Image named 'No_Image' is used in storyboard 'SignupViewController', but couldn't be loaded."
                        )
                }
                if #available(iOS 11.0, tvOS 11.0, *) {}
            }

            fileprivate init() {}
        }
        #endif

        #if os(iOS) || os(tvOS)
        struct wishListViewController: Rswift.StoryboardResourceWithInitialControllerType,
            Rswift.Validatable
        {
            typealias InitialController = WishListViewController

            let bundle = R.hostingBundle
            let name = "WishListViewController"

            static func validate() throws {
                if #available(iOS 11.0, tvOS 11.0, *) {}
            }

            fileprivate init() {}
        }
        #endif

        fileprivate init() {}
    }
    #endif

    fileprivate init() {}
}
