import Foundation
import UIKit

actor StubImageRepository: ImageRepository {
    func loadImage(url: URL) async throws -> UIImage {
        throw ImageRepositoryError.imageNotFound
    }
}
