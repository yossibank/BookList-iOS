import Foundation

final class FileManagement {

    static let shared = FileManagement()

    private var fileManager: FileManager {
        FileManager.default
    }

    private init() { }

    func setData(
        path: String,
        data: Data?
    ) {
        guard let url = try? fileManager.url(
                for: .documentDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: true).appendingPathComponent(path)
        else {
            return
        }

        do {
            try data?.write(to: url)
        } catch {
            Logger.error("couldn't write in file manager \(error.localizedDescription)")
        }
    }
    
    func fetchData() -> [BookListCellData] {
        var data: [BookListCellData] = []

        let documentDirectoryUrl = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask
        )[0]

        do {
            let contentUrls = try FileManager.default.contentsOfDirectory(
                at: documentDirectoryUrl,
                includingPropertiesForKeys: nil
            )
            let files = contentUrls.map { $0.lastPathComponent }

            files.forEach { file in
                guard let url = try? FileManager.default.url(
                        for: .documentDirectory,
                        in: .userDomainMask,
                        appropriateFor: nil,
                        create: false).appendingPathComponent(file)
                else {
                    return
                }

                 do {
                    let json = try Data(contentsOf: url)
                    if let bookListCellData = BookListCellData(json: json) {
                        data.append(bookListCellData)
                    }
                } catch {
                    Logger.error("couldn't create json data \(error.localizedDescription)")
                }
            }
            return data
        } catch {
            Logger.error("couldn't fetch in file manager \(error.localizedDescription)")
            return []
        }
    }
}
