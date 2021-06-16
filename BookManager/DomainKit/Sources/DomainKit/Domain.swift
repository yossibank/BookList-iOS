import APIKit
import Foundation
import Utility

public struct EmptyRepository {}

public struct Domain {
    public struct Usecase {
        public struct Account {
            public static func Signup(
                useTestData: Bool = false
            ) -> UsecaseImpl<Repos.Account.Signup, UserMapper> {
                .init(
                    repository: Repos.Account.Signup(),
                    mapper: UserMapper(),
                    useTestData: useTestData
                )
            }

            public static func Login(
                useTestData: Bool = false
            ) -> UsecaseImpl<Repos.Account.Login, UserMapper> {
                .init(
                    repository: Repos.Account.Login(),
                    mapper: UserMapper(),
                    useTestData: useTestData
                )
            }

            public static func Logout(
                useTestData: Bool = false
            ) -> UsecaseImpl<Repos.Account.Logout, NoMapper> {
                .init(
                    repository: Repos.Account.Logout(),
                    mapper: NoMapper(),
                    useTestData: useTestData
                )
            }
        }

        public struct Book {
            public static func FetchBookList(
                useTestData: Bool = false
            ) -> UsecaseImpl<Repos.Book.Get, BookListMapper> {
                .init(
                    repository: Repos.Book.Get(),
                    mapper: BookListMapper(),
                    useTestData: useTestData
                )
            }

            public static func AddBook(
                useTestData: Bool = false
            ) -> UsecaseImpl<Repos.Book.Post, BookMapper> {
                .init(
                    repository: Repos.Book.Post(),
                    mapper: BookMapper(),
                    useTestData: useTestData
                )
            }

            public static func EditBook(
                useTestData: Bool = false
            ) -> UsecaseImpl<Repos.Book.Put, BookMapper> {
                .init(
                    repository: Repos.Book.Put(),
                    mapper: BookMapper(),
                    useTestData: useTestData
                )
            }
        }
    }
}
