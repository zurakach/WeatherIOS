import Foundation

final class ProdWeatherForceastRepository: WeatherForecastRepository {
    private let remoteAPI: WeatherForecastRemoteAPI
    
    init(remoteAPI: WeatherForecastRemoteAPI) {
        self.remoteAPI = remoteAPI
    }
    
    func loadForecast(for city: CityModel) async throws -> CityForecastModel {
        return try await remoteAPI.loadForecast(for: city)
    }
}
