import Foundation

final class StubDependencyContainer {
    private let stubeatherForecastRepository = StubWeatherForceastRepository()
    private let stubGeocoderRepository = StubGeocoderRepository()
    private let stubLocationRepository = StubLocationRepository()
    private let stubUserPreferencesRepository = StubUserPreferencesRepository()
    private let stubImageRepository = StubImageRepository()
}

extension StubDependencyContainer: WeatherDependencies {
    
    var weatherForecastRepository: WeatherForecastRepository {
        return stubeatherForecastRepository
    }
    
    var geocoderRepository: GeocoderRepository {
        return stubGeocoderRepository
    }
    
    var locationRepository: LocationRepository {
        return stubLocationRepository
    }
    
    var userPreferencesRepository: UserPreferencesRepository {
        return stubUserPreferencesRepository
    }
    
    var imageRepository: ImageRepository {
        return stubImageRepository
    }
    
}
