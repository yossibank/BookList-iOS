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
    
    
}
