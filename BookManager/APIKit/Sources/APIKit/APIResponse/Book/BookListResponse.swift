import Foundation

public struct BookListResponse: DataStructure {
    let status: Int
    let result: [Book]
    let totalCount: Int?
    let totalPages: Int?
    let currentPage: Int?
    let limit: Int?
}
