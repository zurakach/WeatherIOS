import Foundation

protocol WeatherForecastRepository {
    func loadForecast(for city: CityModel) async throws -> CityForecastModel
}
