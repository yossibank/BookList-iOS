import Combine
import FirebaseStorage
import FirebaseStorageSwift

struct FirebaseStorageManager {

    private struct Constant {
        static let userIconPath = "user_icon"
    }

    private static let reference = Storage.storage().reference()

    private static let metaData: StorageMetadata = {
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"
        return metaData
    }()

    static func saveUserIconImage(path: String, uploadImage: Data) -> AnyPublisher<Void, Error> {
        Deferred {
            Future<Void, Error> { promise in
                reference.child(Constant.userIconPath).child(path).putData(
                    uploadImage,
                    metadata: metaData
                ) { _, error in
                    if let error = error {
                        promise(.failure(error))
                        return
                    }
                    promise(.success(()))
                }
            }
        }.eraseToAnyPublisher()
    }

    static func fetchDownloadUrlString(path: String) -> AnyPublisher<String, Error> {
        Deferred {
            Future<String, Error> { promise in
                reference.child(Constant.userIconPath).child(path).downloadURL { url, error in
                    if let error = error {
                        promise(.failure(error))
                        return
                    }

                    guard
                        let urlString = url?.absoluteString
                    else {
                        return
                    }

                    promise(.success(urlString))
                }
            }
        }.eraseToAnyPublisher()
    }
}
