import Foundation

@MainActor final class WeatherForecastPresenter: WeatherForecastInteractorOutput {
    private weak var viewController: WeatherForecastPresentation?
    
    func attach(viewController: WeatherForecastPresentation) {
        self.viewController = viewController
    }
    
    nonisolated func finishedCitySearch(with result: Result<[CityModel], Error>) {
        switch result {
        case .success(let model):
            let cities = model.map { city in
                CityPresentationModel(city: city)
            }
            Task {
                await viewController?.presentSearchCitiesResult(.success(cities), forSearchQuery: "")
            }
        case .failure(let error):
            Task {
                await viewController?.presentSearchCitiesResult(.failure(error), forSearchQuery: "")
            }
            break
        }
    }
    
    nonisolated func startedLoadingWeatherForecast() {
        Task {
            await viewController?.presentWeatherForecastState(.inProgress)
        }
    }
    
    nonisolated func finishedLoading(weatherForecast: CityForecastModel) {
        let forecastPresentation = WeatherForecastPresentationModel(city: weatherForecast.city,
                                                                    temp: weatherForecast.temp,
                                                                    weatherDescription: weatherForecast.weatherDescription,
                                                                    imageUrl: weatherForecast.imageUrl)
        Task {
            await viewController?.presentWeatherForecastState(.finished(forecastPresentation))
        }
    }
    
    nonisolated func failedLoadingWeatherForecast(with error: Error) {
        Task {
            await viewController?.presentWeatherForecastState(.failed(error))
        }
    }
}
