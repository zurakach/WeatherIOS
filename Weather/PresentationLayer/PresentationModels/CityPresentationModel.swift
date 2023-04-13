import Foundation

struct CityPresentationModel {
    let city: CityModel
    
    init(city: CityModel) {
        self.city = city
    }
    
    var name: String {
        return "\(city.name), \(city.state)"
    }
}
