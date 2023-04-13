import Foundation
import CoreLocation

final class StubLocationRepository: NSObject, LocationRepository {
    func requestLocation() async throws -> LocationModel {
        return LocationModel(latitude: 37.425713,
                             longitude: -122.1703695)
    }
}
