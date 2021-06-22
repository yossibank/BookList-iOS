import Foundation
import Utility

@propertyWrapper
class FileStorage<T: Codable> {
    private var value: T?
    private let file: FileName

    init(file: FileName) {
        self.file = file
        value = LocalStorageManager.getObjectFromFile(fileName: file)
    }

    var wrappedValue: T? {
        get {
            value
        }
        set {
            value = newValue

            let file = self.file

            if let data = newValue {
                LocalStorageManager.writeObjectToFile(fileName: file, jsonEncodable: data)
            } else {
                /// setting value to nil will clear cache
                LocalStorageManager.deleteFile(fileName: file)
            }
        }
    }
}

private struct LocalStorageManager {

    private enum PathSearchError: Error {
        case pathNotFound
    }

    private struct Constants {
        static let fileWritingDebounce = DispatchTimeInterval.milliseconds(200)
    }

    enum DispatchQueueLabel: String {
        case localStorageManager
    }

    static func clearDiskCache(
        dispatchQueue: DispatchQueue = DispatchQueue(
            label: DispatchQueueLabel.localStorageManager.rawValue
        )
    ) {
        dispatchQueue.async {
            FileName.allCases.forEach { fileName in
                Self.deleteFile(fileName: fileName)
            }
        }
    }

    static func removeAll() {
        let manager = FileManager.default

        guard
            let docURL = manager.urls(
                for: .applicationSupportDirectory,
                in: .userDomainMask
            ).first
        else {
            return
        }

        let bundleId = Bundle.main.bundleIdentifier ?? ""
        let dirURL = docURL.appendingPathComponent(bundleId)

        manager.enumerator(at: dirURL, includingPropertiesForKeys: nil)?.forEach { url in
            if let url = url as? URL {
                try? manager.removeItem(at: url)
            }
        }
    }

    static func getObjectFromFile<T: Decodable>(fileName: FileName) -> T? {
        do {
            let fileURL = try retrieveConfiguredFileURL(fileName: fileName)
            let localData = try Data(contentsOf: fileURL, options: .alwaysMapped)
            let localItems = try JSONDecoder().decode(T.self, from: localData)
            return localItems
        } catch {
            logError(
                errorDescription: error.localizedDescription,
                functionName: #function
            )
            return nil
        }
    }

    static func writeObjectToFile<T: Encodable>(
        fileName: FileName,
        jsonEncodable: T,
        dispatchQueue: DispatchQueue = DispatchQueue(
            label: DispatchQueueLabel.localStorageManager.rawValue
        )
    ) {
        dispatchQueue.async {
            let jsonEncoder = JSONEncoder()

            guard let jsonData = try? jsonEncoder.encode(jsonEncodable) else {
                return
            }

            do {
                let fileURL = try self.retrieveConfiguredFileURL(fileName: fileName)
                try jsonData.write(to: fileURL, options: .atomic)
            } catch {
                self.logError(
                    errorDescription: error.localizedDescription,
                    functionName: #function
                )
            }
        }
    }

    static func deleteFile(
        fileName: FileName,
        dispatchQueue: DispatchQueue = DispatchQueue(
            label: DispatchQueueLabel.localStorageManager.rawValue
        )
    ) {
        dispatchQueue.async {
            do {
                let fileURL = try self.retrieveConfiguredFileURL(fileName: fileName)
                try FileManager.default.removeItem(at: fileURL)
            } catch {
                DispatchQueue.main.async {
                    self.logError(
                        errorDescription: error.localizedDescription,
                        functionName: #function
                    )
                }
            }
        }
    }
}

private extension LocalStorageManager {

    static func retrieveConfiguredFileURL(
        fileName: FileName,
        excludeFromBackup: Bool = true
    ) throws -> URL {
        let bundleId = Bundle.main.bundleIdentifier ?? ""
        let appSupportDir = FileManager.SearchPathDirectory.applicationSupportDirectory
        let userMask = FileManager.SearchPathDomainMask.userDomainMask

        guard
            let appSupportDirURL: URL = FileManager.default.urls(
                for: appSupportDir,
                in: userMask
            ).first
        else {
            throw PathSearchError.pathNotFound
        }

        let dirURL = appSupportDirURL.appendingPathComponent(bundleId, isDirectory: true)
        var isDir: ObjCBool = true

        if !FileManager.default.fileExists(atPath: dirURL.path, isDirectory: &isDir) {
            try? FileManager.default.createDirectory(
                at: dirURL,
                withIntermediateDirectories: true,
                attributes: nil
            )
        }

        var fullURL = dirURL.appendingPathComponent(fileName.rawValue, isDirectory: false)

        if excludeFromBackup {
            var resourceValues = URLResourceValues()
            resourceValues.isExcludedFromBackup = true
            try? fullURL.setResourceValues(resourceValues)
        }

        return fullURL
    }

    static func logError(errorDescription: String, functionName: String) {
        let log = String(describing: self) + " " + functionName + " error:" + errorDescription
        Logger.debug(message: log)
    }
}
