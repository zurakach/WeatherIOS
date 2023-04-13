import Foundation
import UIKit

@MainActor protocol WeatherRouting {
    var initialViewController: UIViewController { get }
    
    func makeWeatherForecastDetailsViewModel() -> WeatherForecastDetailsViewModel
    func makeCitySearchResultsViewController() -> CitySearchResultsViewController
    
    func displayError(title: String, message: String, retryAction: (()->Void)?)
}
