import Foundation

protocol WeatherDependencies {
    var weatherForecastRepository: WeatherForecastRepository { get }
    var geocoderRepository: GeocoderRepository { get }
    var locationRepository: LocationRepository { get }
    var userPreferencesRepository: UserPreferencesRepository { get }
    var imageRepository: ImageRepository { get }
}
