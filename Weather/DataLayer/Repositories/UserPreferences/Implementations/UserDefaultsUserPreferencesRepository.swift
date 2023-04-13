import Foundation

final class UserDefaultsUserPreferencesRepository {
    // TODO: Encode LocationModel
    let latituteKey = "UserDefaultsUserPreferencesRepositoryLatitude"
    let longituteKey = "UserDefaultsUserPreferencesRepositoryLongitutde"
}

extension UserDefaultsUserPreferencesRepository: UserPreferencesRepository {
    func setLatestUserLocation(_ location: LocationModel) async throws {
        let defaults = UserDefaults.standard
        defaults.setValue(location.latitude, forKey: latituteKey)
        defaults.setValue(location.longitude, forKey: longituteKey)
    }
    
    func getLatestUserLocation() async throws -> LocationModel {
        let defaults = UserDefaults.standard
        let lat = defaults.double(forKey: latituteKey)
        let lon = defaults.double(forKey: longituteKey)
        // Cheking if data was set or not. I'm sure there's a better way
        if lat == 0 {
            throw UserPreferencesRepositoryError.locationNotFound
        }
        return LocationModel(latitude: lat, longitude: lon)
    }
    
    
}
