import FirebaseStorage

final class FirebaseStorageManager {

    static let shared = FirebaseStorageManager()

    private let database = Storage.storage()

    private let metaData: StorageMetadata = {
        let metaData = StorageMetadata()
        metaData.contentType = ""
        return metaData
    }()

    private init() {}

    func saveUserIconImage(
        path: String,
        uploadImage: Data
    ) {
        database
            .reference()
            .child("")
            .child(path)
            .putData(
                uploadImage,
                metadata: metaData
            ) { _, error in
                if let error = error {
                    print("FirebaseStorageへのデータの保存に失敗しました: \(error)")
                    return
                }
            }
    }

    func fetchDownloadUrlString(
        path: String,
        completion: @escaping (String) -> Void
    ) {
        database
            .reference()
            .child("")
            .child(path)
            .downloadURL { url, error in
                if let error = error {
                    print("FirebaseStorageからのダウンロードに失敗しました: \(error)")
                }
                guard
                    let urlString = url?.absoluteString
                else {
                    return
                }

                completion(urlString)
            }
    }
}
