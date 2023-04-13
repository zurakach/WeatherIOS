import Foundation

enum LocationRepositoryError: Error {
    case unableToGetLocation
}

protocol LocationRepository {
    func requestLocation() async throws -> LocationModel
}
