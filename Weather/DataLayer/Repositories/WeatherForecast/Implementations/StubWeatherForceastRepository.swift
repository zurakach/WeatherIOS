import Foundation

final class StubWeatherForceastRepository: WeatherForecastRepository {
    func loadForecast(for city: CityModel) async throws -> CityForecastModel {
        return CityForecastModel(city: city,
                                 weatherDescription: "Rain",
                                 temp: 100,
                                 imageUrl:URL(string: "https://openweathermap.org/img/wn/50n@2x.png")!)
    }
}
