import Foundation
import CoreLocation

final class CLGeocoderRepository: GeocoderRepository {
    func findCities(with name: String) async throws -> [CityModel] {
        let geocoder = CLGeocoder()
        // TODO: Use api that searches only city name, not places
        let placemarks = try await geocoder.geocodeAddressString(name)
        return placemarks.compactMap { placemark in
            guard let name = placemark.locality,
                  let state = placemark.administrativeArea,
                  let location = placemark.location else {
                return nil
            }
            let coordinate = location.coordinate
            return CityModel(name: name,
                             state: state,
                             location: LocationModel(latitude: coordinate.latitude,
                                                     longitude: coordinate.longitude))
        }
    }
    
    func findCity(for location: LocationModel) async throws -> CityModel {
        let clLocation = CLLocation(latitude: location.latitude, longitude: location.longitude)
        let geocoder = CLGeocoder()
        let placemarks = try await geocoder.reverseGeocodeLocation(clLocation)
        guard let placemark = placemarks.first,
                let locality = placemark.locality,
                let state = placemark.administrativeArea else {
            throw GeocoderRepositoryError.cityNotFound
        }
        return CityModel(name: locality, state: state, location: location)
    }

}
