import Foundation

enum UserPreferencesRepositoryError: Error {
    case locationNotFound
}

protocol UserPreferencesRepository {
    func setLatestUserLocation(_ location: LocationModel) async throws
    func getLatestUserLocation() async throws -> LocationModel
}
