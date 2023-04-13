import Foundation


protocol WeatherForecastInteractorInput: AnyObject {
    func loadLocationForecast()
    func loadLastShownForecast()
    func searchCities(for query: String)
    func loadForecast(for city: CityModel)
    func saveLastShownForecastCity(_ city: CityModel)
}


protocol WeatherForecastInteractorOutput: AnyObject {
    func finishedCitySearch(with result: Result<[CityModel], Error>)
    
    func startedLoadingWeatherForecast()
    func finishedLoading(weatherForecast: CityForecastModel)
    func failedLoadingWeatherForecast(with error: Error)
}


final actor WeatherForecastInteractor {
    private let dependencies: WeatherDependencies
    private let presenter: WeatherForecastInteractorOutput
    
    private var forecastLoadingTask: Task<Void, Never>?
    private var searchCitiesTask: Task<Void, Never>?
    private var saveLastShownCityTask: Task<Void, Never>?
    
    init(dependencies: WeatherDependencies, presenter: WeatherForecastInteractorOutput) {
        self.dependencies = dependencies
        self.presenter = presenter
    }
    
    // Create private* counterparts for loading so we can have non nonisolated methods
    private func privateLoadLocationForecast() {
        forecastLoadingTask?.cancel()
        forecastLoadingTask = Task {
            do {
                presenter.startedLoadingWeatherForecast()
                let loc = try await dependencies.locationRepository.requestLocation()
                let city = try await dependencies.geocoderRepository.findCity(for: loc)
                let weather = try await dependencies.weatherForecastRepository.loadForecast(for: city)
                presenter.finishedLoading(weatherForecast: weather)
            } catch {
                presenter.failedLoadingWeatherForecast(with: error)
            }
        }
    }
    
    private func privateLoadLastShownForecast() {
        forecastLoadingTask?.cancel()
        forecastLoadingTask = Task {
            do {
                presenter.startedLoadingWeatherForecast()
                // TODO: Save city details in preferences to avoid unnecessary loading.
                let loc = try await dependencies.userPreferencesRepository.getLatestUserLocation()
                let city = try await dependencies.geocoderRepository.findCity(for: loc)
                let weather = try await dependencies.weatherForecastRepository.loadForecast(for: city)
                presenter.finishedLoading(weatherForecast: weather)
            } catch {
                presenter.failedLoadingWeatherForecast(with: error)
            }
        }
    }
    
    private func privateLoadForecast(for city: CityModel) {
        forecastLoadingTask?.cancel()
        forecastLoadingTask = Task {
            do {
                presenter.startedLoadingWeatherForecast()
                let weather = try await dependencies.weatherForecastRepository.loadForecast(for: city)
                presenter.finishedLoading(weatherForecast: weather)
            } catch {
                presenter.failedLoadingWeatherForecast(with: error)
            }
        }
    }
    
    // TODO: It seems that loading forecast and searching cities can be done independently.
    // TODO: Maybe it is worth to introduce WeatherForcastWorker and CitySearchWorker.
    private func privateSearchCities(for query: String) {
        searchCitiesTask?.cancel()
        forecastLoadingTask = Task {
            do {
                let cities = try await dependencies.geocoderRepository.findCities(with: query)
                presenter.finishedCitySearch(with: .success(cities))
            } catch {
                presenter.finishedCitySearch(with: .failure(error))
            }
        }
    }
    
    private func privateSaveLastShownForecastCity(_ city: CityModel) {
        saveLastShownCityTask?.cancel()
        saveLastShownCityTask = Task {
            // Just ignore errors here
            try? await dependencies.userPreferencesRepository.setLatestUserLocation(city.location)
        }
    }
}

extension WeatherForecastInteractor: WeatherForecastInteractorInput {
    
    nonisolated func loadLocationForecast(){
        Task {
            await privateLoadLocationForecast()
        }
    }
    
    nonisolated func loadLastShownForecast() {
        Task {
            await privateLoadLastShownForecast()
        }
    }
    
    nonisolated func loadForecast(for city: CityModel) {
        Task {
            await privateLoadForecast(for: city)
        }
    }
    
    nonisolated func searchCities(for query: String) {
        Task {
            await privateSearchCities(for: query)
        }
    }
    
    nonisolated func saveLastShownForecastCity(_ city: CityModel) {
        Task {
            await privateSaveLastShownForecastCity(city)
        }
    }
}


