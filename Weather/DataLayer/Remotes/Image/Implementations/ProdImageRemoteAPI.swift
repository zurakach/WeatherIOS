import Foundation
import UIKit

final class ProdImageRemoteAPI: ImageRemoteAPI {
    func loadImage(with url: URL) async throws -> UIImage {
        let (data, _) = try await URLSession.shared.data(from: url)
        guard let image = UIImage(data: data) else {
            throw RemoteAPIError.invalidResponse
        }
        return image
    }
}
