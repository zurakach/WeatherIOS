import Foundation

struct CityForecastModel: Equatable {
    let city: CityModel
    let weatherDescription: String
    let temp: Double
    
    //TODO: Ideally image should be separate model. Model would provide appropriate urls based on size and resolution.
    let imageUrl: URL
}
