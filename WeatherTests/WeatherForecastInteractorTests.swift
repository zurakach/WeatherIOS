import Foundation

import XCTest
@testable import Weather

final class WeatherForecastInteractorTests: XCTestCase {

    var dependencies = StubDependencyContainer()
    var presenter: MockWeatherForecastPresenter!
    var interactor: WeatherForecastInteractor!
    
    override func setUpWithError() throws {
        presenter = MockWeatherForecastPresenter()
        interactor = WeatherForecastInteractor(dependencies: dependencies, presenter: presenter)
    }
    
    // TODO: These are not good tests, Stubs always return same value. Need to return different values for diferent locations
    // TODO: Need to have timouts
    
    func testLoadLocationForecast() async throws {
        interactor.loadLocationForecast()
        let _ = await presenter.startedLoadingWeatherForecastFuture.value
        let forecast = await presenter.finishedLoadingFuture.value
        let location = try await dependencies.locationRepository.requestLocation()
        let city = try await dependencies.geocoderRepository.findCity(for: location)
        let expectedForecast = try await dependencies.weatherForecastRepository.loadForecast(for: city)
        XCTAssertEqual(forecast, expectedForecast)
    }
    
    func testLoadLastShownForecast() async throws {
        interactor.loadLastShownForecast()
        let _ = await presenter.startedLoadingWeatherForecastFuture.value
        let forecast = await presenter.finishedLoadingFuture.value
        let location = try await dependencies.userPreferencesRepository.getLatestUserLocation()
        let city = try await dependencies.geocoderRepository.findCity(for: location)
        let expectedForecast = try await dependencies.weatherForecastRepository.loadForecast(for: city)
        XCTAssertEqual(forecast, expectedForecast)
    }
    
    func testLoadForecast() async throws {
        let location = try await dependencies.userPreferencesRepository.getLatestUserLocation()
        let city = try await dependencies.geocoderRepository.findCity(for: location)
        interactor.loadForecast(for: city)
        let _ = await presenter.startedLoadingWeatherForecastFuture.value
        let forecast = await presenter.finishedLoadingFuture.value
        let expectedForecast = try await dependencies.weatherForecastRepository.loadForecast(for: city)
        XCTAssertEqual(forecast, expectedForecast)
    }
    
    func testSearchCities() async throws {
        let name = "TEST"
        interactor.searchCities(for: name)
        let cities = await presenter.finishedCitySearchFuture.value
        let expectedCities = try await dependencies.geocoderRepository.findCities(with: name)
        XCTAssertEqual(try cities.get(), expectedCities)
    }
    
    // TODO: Test saveLastShownForecastCity
    // TODO: Test with stubs that return errors
}
