import Foundation
import UIKit

actor ProdImageRepository: ImageRepository {
    private let remoteAPI: ImageRemoteAPI
    private var cache = [URL:UIImage]()
    
    init(remoteAPI: ImageRemoteAPI) {
        self.remoteAPI = remoteAPI
    }
    
    private func cacheImage(url: URL, image: UIImage) {
        cache[url] = image
    }
    
    func loadImage(url: URL) async throws -> UIImage {
        if let image = cache[url] {
            return image
        }
        let image = try await remoteAPI.loadImage(with: url)
        cacheImage(url: url, image: image)
        return image
    }
}
