import Foundation

protocol WeatherForecastRemoteAPI {
    func loadForecast(for city: CityModel) async throws -> CityForecastModel
}
