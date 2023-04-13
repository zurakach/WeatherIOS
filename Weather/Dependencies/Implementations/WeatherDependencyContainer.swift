import Foundation

final class WeatherDependencyContainer {
    let prodWeatherForecastRepository = ProdWeatherForceastRepository(remoteAPI: OpenWeatherForcastRemoteAPI())
    let clGeocoderRepository = CLGeocoderRepository()
    let clLocationRepository = CLLocationRepository()
    let udUserPreferencesRepository = UserDefaultsUserPreferencesRepository()
    let prodImageRepository = ProdImageRepository(remoteAPI: ProdImageRemoteAPI())
}

extension WeatherDependencyContainer: WeatherDependencies {
    
    var weatherForecastRepository: WeatherForecastRepository {
        return prodWeatherForecastRepository
    }
    
    var geocoderRepository: GeocoderRepository {
        return clGeocoderRepository
    }
    
    var locationRepository: LocationRepository {
        return clLocationRepository
    }
    
    var userPreferencesRepository: UserPreferencesRepository {
        return udUserPreferencesRepository
    }
    
    var imageRepository: ImageRepository {
        return prodImageRepository
    }
    
}
