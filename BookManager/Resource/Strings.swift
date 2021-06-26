struct StringResources {

    struct General {
        @Localizable static var yes = "yes"
        @Localizable static var no = "no"
        @Localizable static var success = "success"
        @Localizable static var failure = "failure"
        @Localizable static var close = "close"
        @Localizable static var error = "error"
        @Localizable static var pleaseCheckAgainContents = "please_check_again_contents"
        @Localizable static var mailAddress = "mail_address"
        @Localizable static var password = "password"
        @Localizable static var logout = "logout"
        @Localizable static var selectUser = "select_user"
        @Localizable static var nickName = "nick_name"
    }

    struct Account {
        @Localizable static var login = "login"
        @Localizable static var logout = "logout"
        @Localizable static var createAccount = "create_account"
        @Localizable static var showPassword = "show_password"
        @Localizable static var selectIconImage = "select_chat_image"
        @Localizable static var nickName = "nickname"
    }

    struct Book {
        @Localizable static var title = "title"
        @Localizable static var bookTitle = "book_title"
        @Localizable static var price = "price"
        @Localizable static var purchaseDate = "purchase_date"
        @Localizable static var yen = "yen"
        @Localizable static var tax = "tax"
        @Localizable static var plus = "plus"
        @Localizable static var selectImage = "select_image"
        @Localizable static var takePicture = "take_a_picture"
    }

    struct TabBar {
        @Localizable static var bookList = "book_list"
        @Localizable static var wishList = "wish_list"
        @Localizable static var account = "account"
    }

    struct Navigation {
        @Localizable static var done = "done"
        @Localizable static var add = "add"
        @Localizable static var cancel = "cancel"
        @Localizable static var startTalk = "start_talk"

        struct Title {
            @Localizable static var wishList = "wish_list"
            @Localizable static var talkList = "talk_list"
            @Localizable static var bookList = "book_list"
            @Localizable static var bookAdd = "book_add"
            @Localizable static var bookEdit = "book_edit"
            @Localizable static var account = "account"
        }
    }

    struct Error {
        @Localizable static var failedSignup = "failed_signup"
        @Localizable static var failedLogin = "failed_login"
        @Localizable static var failedLogout = "failed_logout"
        @Localizable static var failedBookList = "failed_book_list"
        @Localizable static var failedBookAdd = "failed_book_add"
        @Localizable static var failedBookEdit = "failed_book_edit"
    }

    struct Alert {
        @Localizable static var ok = "ok"
        @Localizable static var successBookAdd = "success_book_add"
        @Localizable static var successBookEdit = "success_book_edit"
        @Localizable static var didYouLogout = "did_you_logout"
    }

    struct Validation {
        @Localizable static var notFilled = "not_filled"
        @Localizable static var notLongerTitleText = "not_longer_title_text"
        @Localizable static var notCorrectFormatEmail = "not_correct_format_email"
        @Localizable static var notLengthPassword = "not_length_password"
        @Localizable static var notMatchingPassowrd = "not_matching_password"
        @Localizable static var maybeAlreadyEamil = "maybe_already_email"
        @Localizable static var onlyInputNumber = "only_input_number"
    }

    struct Button {
        @Localizable static var nextTitle = "next_button_title"
        @Localizable static var cancelButtonTitle = "cancel_button_title"
    }
}
