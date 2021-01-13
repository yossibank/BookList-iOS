import Foundation
import UIKit

final class ImageLoader {

    enum ImageType {
        case string(urlString: String)
        case url(url: URL?)
    }

    /* キャッシュのディスク容量200MB */
    private init() {
        URLCache.shared.diskCapacity = 200 * (1000 * 1000)
    }

    static var noImage = Resources.Images.General.noImage
    
    static let shared = ImageLoader()

    typealias DownloadImageItem = (image: UIImage, isCachedOnMemoryOrDisk: Bool)
    typealias Completion = (DownloadImageItem) -> Void

    private let tasksQueue: DispatchQueue = DispatchQueue(label: "imageLoader")

    private var _tasks: [URL : [Completion]] = [:]

    private var tasks: [URL : [Completion]] {
        get {
            tasksQueue.sync {
                return _tasks
            }
        }

        set {
            tasksQueue.sync {
                _tasks = newValue
            }
        }
    }

    /**
     * If something goes wrong with downloading or decoding,
     * `noImage` will be returned.
     * If specificying `immidiately` and a cached image can be found
     * the image callback will be returned immediately on the calling
     * thread, be careful in this case, when setting image to an image
     * view by switching to main thread.
     */
    func loadImage(
        immediatery: Bool = false,
        with type: ImageType,
        forceUsingNoImage: Bool = false,
        completion: @escaping Completion
    ) {
        assert(Thread.current == Thread.main)

        var imageUrl: URL? {

            if case .string(let string) = type {

                return URL(string: string)

            } else if case .url(let imageUrl) = type {

                if let string = imageUrl?.absoluteString {

                    guard let urlString = URL(string: string) else {
                        return imageUrl
                    }

                    return urlString

                } else {

                    return imageUrl

                }
            }

            return nil

        }

        guard let url = imageUrl else {
            self.finish(immediately: immediatery) {
                if let noImage = Self.noImage {
                    completion((noImage, true))
                }
            }
            return
        }

        let request = URLRequest(url: url)

        if let cachedResponse = URLCache.shared.cachedResponse(for: request),
           let image = UIImage(data: cachedResponse.data)
        {
            self.finish(immediately: immediatery) {
                completion((image, true))
            }
            return
        }

        if let completions = self.tasks[url], completions.isEmpty == false {
            self.tasks[url] = completions + [completion]
            return
        } else {
            self.tasks[url] = [completion]
        }

        URLSession.shared.retryDataTask(request: request) { [weak self] data, _, error in
            guard let self = self else { return }

            if let error = error {
                self.finish(immediately: immediatery) {
                    if let noImage = Self.noImage {
                        completion((image: noImage, isCachedOnMemoryOrDisk: false))
                    }
                }
                return
            }

            guard let data = data,
                  let image = UIImage(data: data)
            else {
                self.finish(immediately: immediatery) {
                    if let noImage = Self.noImage {
                        completion((image: noImage, isCachedOnMemoryOrDisk: false))
                    }
                }
                return
            }

            guard let completionBlocks = self.tasks[url] else { return }

            completionBlocks.forEach { completionBlock in
                self.finish {
                    completionBlock((image: image, isCachedOnMemoryOrDisk: false))
                }
            }

            self.tasks[url] = nil

        }.resume()
    }

    func cancel(url: URL) {
        tasks[url] = nil
    }

    private func finish(
        immediately: Bool = false,
        finished: @escaping VoidBlock
    ) {
        if immediately {
            finished()
        } else {
            DispatchQueue.main.async(execute: finished)
        }
    }
}

private extension URLSession {

    func retryDataTask(
        request: URLRequest,
        times: Int = 0,
        wait: UInt32 = 300 * 1000,
        completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void
    ) -> URLSessionDataTask {

        self.dataTask(with: request) { data, response, error in
            if error != nil, times > 0 {
                usleep(wait)

                self.retryDataTask(
                    request: request,
                    times: times - 1,
                    wait: wait,
                    completionHandler: completionHandler
                ).resume()
            } else {
                DispatchQueue.main.async {
                    completionHandler(data, response, error)
                }
            }
        }
    }
}
