import Foundation

enum WeatherForecastPresentationLoadingStateModel {
    case inProgress
    case finished(WeatherForecastPresentationModel)
    case failed(Error)
}

struct WeatherForecastPresentationModel: Equatable {
    let city: CityModel
    private let temp: Double
    let weatherDescription: String
    let imageUrl: URL
    
    var locationName: String {
        return "\(city.name), \(city.state)"
    }
    
    // TODO: Add requesting temperature in different metrics
    var temperature: String {
        return String(format: "%.1f' F", temp)
    }
    
    init(city: CityModel, temp: Double, weatherDescription: String, imageUrl: URL) {
        self.city = city
        self.temp = temp
        self.weatherDescription = weatherDescription
        self.imageUrl = imageUrl
    }
}
