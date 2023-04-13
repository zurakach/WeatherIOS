import UIKit

enum ImageRepositoryError: Error {
    case imageNotFound
}

protocol ImageRepository {
    func loadImage(url: URL) async throws -> UIImage
}
