import Foundation
import Combine

final class MockWeatherForecastPresenter: WeatherForecastInteractorOutput {
    
    // TODO: There must be a better way to handle multiple futures.
    typealias MockFuture<T> = Future<T, Never>
    typealias CitySearchResult = Result<[CityModel], Error>
    
    var finishedCitySearchFuture: MockFuture<CitySearchResult>!
    var startedLoadingWeatherForecastFuture: MockFuture<Void>!
    var finishedLoadingFuture: MockFuture<CityForecastModel>!
    var failedLoadingWeatherForecast: MockFuture<Error>!
    
    private var finishedCitySearchPromise: MockFuture<CitySearchResult>.Promise!
    private var startedLoadingWeatherForecastPromise: MockFuture<Void>.Promise!
    private var finishedLoadingPromise: MockFuture<CityForecastModel>.Promise!
    private var failedLoadingWeatherPromise: MockFuture<Error>.Promise!
    
    init() {
        finishedCitySearchFuture = Future({ promise in
            self.finishedCitySearchPromise = promise
        })
        startedLoadingWeatherForecastFuture = Future({ promise in
            self.startedLoadingWeatherForecastPromise = promise
        })
        finishedLoadingFuture = Future({ promise in
            self.finishedLoadingPromise = promise
        })
        failedLoadingWeatherForecast = Future({ promise in
            self.failedLoadingWeatherPromise = promise
        })
    }
    
    func finishedCitySearch(with result: Result<[CityModel], Error>) {
        finishedCitySearchPromise(.success(result))
    }
    
    func startedLoadingWeatherForecast() {
        startedLoadingWeatherForecastPromise(.success(()))
    }
    
    func finishedLoading(weatherForecast: CityForecastModel) {
        finishedLoadingPromise!(.success(weatherForecast))
    }
    
    func failedLoadingWeatherForecast(with error: Error) {
        failedLoadingWeatherPromise!(.success(error))
    }
    
}
