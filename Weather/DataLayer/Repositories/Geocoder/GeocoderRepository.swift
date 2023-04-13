import Foundation

enum GeocoderRepositoryError: Error {
    case cityNotFound
}

protocol GeocoderRepository {
    func findCities(with name: String) async throws -> [CityModel]
    func findCity(for location: LocationModel) async throws -> CityModel
}
