import Foundation

final class StubUserPreferencesRepository: UserPreferencesRepository {

    func setLatestUserLocation(_ location: LocationModel) async throws {
    }
    
    func getLatestUserLocation() async throws -> LocationModel {
        return LocationModel(latitude: 37.425713,
                             longitude: -122.1703695)
    }
}
