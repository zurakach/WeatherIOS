import Foundation

final class StubGeocoderRepository: GeocoderRepository {
    // If this property is set, Repository will respond with this error to every request.
    var forcedError: GeocoderRepositoryError?
    
    private let paloAlto = CityModel(name: "Palo Alto", state: "California", location: LocationModel(
        latitude: 37.425713,
        longitude: -122.1703695))
    
    private let mountainView = CityModel(name: "Mountain View", state: "California", location: LocationModel(
        latitude: 37.4133847,
        longitude: -122.2247943))
    
    func findCities(with name: String) async throws -> [CityModel] {
        if let forcedError {
            throw forcedError
        }
        return [paloAlto, mountainView]
    }
    
    func findCity(for location: LocationModel) async throws -> CityModel {
        if let forcedError {
            throw forcedError
        }
        return paloAlto
    }
}
