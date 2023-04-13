import Foundation

fileprivate struct OpenWeatherResponseModel: Codable {
    let main: OpenWeatherResponseMainModel
    let weather: [OpenWeatherResponseWeatherModel]
}

fileprivate struct OpenWeatherResponseMainModel: Codable {
    let temp: Double
}

fileprivate struct OpenWeatherResponseWeatherModel: Codable {
    let description: String
    let icon: String
}


final class OpenWeatherForcastRemoteAPI: WeatherForecastRemoteAPI {
    private let baseUrl = "https://api.openweathermap.org/data/2.5/weather"
    private let apiKey = APIKeysWorker.openWeatherAPIKey
    
    
    func loadForecast(for city: CityModel) async throws -> CityForecastModel {
        // TODO: Ideally I would build some kind of request builder for generating a url with params
        let url = URL(string: "\(baseUrl)?lat=\(city.location.latitude)&lon=\(city.location.longitude)&appid=\(apiKey)&units=imperial")!
        
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let response = response as? HTTPURLResponse,
              response.statusCode == 200 else {
            throw RemoteAPIError.invalidResponse
        }
        
        guard let responseModel = try? JSONDecoder().decode(OpenWeatherResponseModel.self, from: data),
              let weather = responseModel.weather.first else {
            throw RemoteAPIError.invalidResponse
        }
        
        return CityForecastModel(city: city,
                                 weatherDescription: weather.description,
                                 temp: responseModel.main.temp,
                                 imageUrl: Self.iconImageURL(name: weather.icon))
    }
    
    static private func iconImageURL(name: String) -> URL {
        return URL(string:"https://openweathermap.org/img/wn/\(name)@2x.png")!
    }
}
