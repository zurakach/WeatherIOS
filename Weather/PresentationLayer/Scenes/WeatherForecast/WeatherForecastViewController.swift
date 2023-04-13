import UIKit


@MainActor protocol WeatherForecastPresentation: AnyObject {
    func presentWeatherForecastState(_ state: WeatherForecastPresentationLoadingStateModel)
    func presentSearchCitiesResult(_ result: Result<[CityPresentationModel], Error>, forSearchQuery query: String)
}

final class WeatherForecastViewController: NiblessViewController {
    private let dependencyContainer: WeatherDependencies
    private let router: WeatherRouting
    private let interactor: WeatherForecastInteractorInput
    
    private var forecastDetailsView: WeatherForecastDetailsUIKitView!
    private var forecastDetailsViewModel: WeatherForecastDetailsViewModel!
    private var searchController: UISearchController!
    private var searchResultsViewController: CitySearchResultsViewController!
        
    // VC needs to display forecast for user's location first.
    // If this fails, then try to load last shown location.
    // If user has searches for some other location while loading user's location,
    // searched forecast is shown. There is no need to load
    // either user's location's forecast or last forecast.
    // Using this enum to keep track of which forecast is being loaded.
    private enum LoadForecastType {
        case none, location, last, searchedCity(CityPresentationModel)
    }
    private var forecastType = LoadForecastType.none
    
    
    init(dependencyContainer: WeatherDependencies, router: WeatherRouting, interactor: WeatherForecastInteractorInput) {
        self.dependencyContainer = dependencyContainer
        self.router = router
        self.interactor = interactor
        super.init()
    }
    
    override func loadView() {
        self.view = UIView()
        view.backgroundColor = .white
        
        let forecastView = WeatherForecastDetailsUIKitView(frame: .zero)
        let forecastViewModel = router.makeWeatherForecastDetailsViewModel()
        forecastViewModel.attach(view: forecastView)
        
        self.view.addSubview(forecastView)
        self.forecastDetailsView = forecastView
        self.forecastDetailsViewModel = forecastViewModel
        
        // TODO: Make this code reusable
        forecastView.translatesAutoresizingMaskIntoConstraints = false
        let layoutGuide = self.view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            layoutGuide.topAnchor.constraint(equalTo: forecastView.topAnchor),
            layoutGuide.leadingAnchor.constraint(equalTo: forecastView.leadingAnchor),
            layoutGuide.trailingAnchor.constraint(equalTo: forecastView.trailingAnchor),
            layoutGuide.bottomAnchor.constraint(equalTo: forecastView.bottomAnchor)
        ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchResultsViewController = router.makeCitySearchResultsViewController()
        searchResultsViewController.searchDelegate = self
        searchController = UISearchController(searchResultsController: searchResultsViewController)
        searchController.searchBar.delegate = self
        self.navigationItem.searchController = searchController
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        switch forecastType {
        case .none:
            self.loadUsersLocationForecast()
        default:
            break
        }
    }
    
    private func loadUsersLocationForecast() {
        forecastType = .location
        interactor.loadLocationForecast()
    }
    
    private func loadLastShownForecast() {
        forecastType = .last
        interactor.loadLastShownForecast()
    }
    
    private func loadForecast(for city: CityPresentationModel) {
        forecastType = .searchedCity(city)
        interactor.loadForecast(for: city.city)
    }
    
    private func handleLoadForecastError(_ error: Error) {
        switch forecastType {
        case .none:
            assertionFailure("LoadingType must be set at this point")
        case .location:
            // TODO: Ideally I have to check what type of error it is and handle it accordingly. For now just show error.
            router.displayError(title: "Unable to load location forecast", message: error.localizedDescription, retryAction: nil)
            loadLastShownForecast()
        case .last:
            router.displayError(title: "Unable to load last shown forecast", message: error.localizedDescription, retryAction: nil)
        case .searchedCity(let city):
            router.displayError(title: "Unable to load forecast", message: error.localizedDescription) { [weak self] in
                self?.loadForecast(for: city)
            }
        }
    }
}

extension WeatherForecastViewController: WeatherForecastPresentation {
    func presentWeatherForecastState(_ state: WeatherForecastPresentationLoadingStateModel) {
        //TODO: Use locilized strings for errors
        switch state {
        case .inProgress:
            break
        case .finished(let forecast):
            self.interactor.saveLastShownForecastCity(forecast.city)
        case .failed(let error):
            handleLoadForecastError(error)
        }
        self.forecastDetailsViewModel?.configure(with: state)
    }
    
    func presentSearchCitiesResult(_ result: Result<[CityPresentationModel], Error>, forSearchQuery query: String) {
        switch result {
        case .success(let success):
            searchResultsViewController.configureWithCities(success)
        case .failure(_):
            // Do nothing for now
//            router.displayError(title: "Unable to search", message: failure.localizedDescription, retryAction: nil)
            break
        }
    }
    
}

extension WeatherForecastViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text,
              text.count > 2 else {
            return
        }
        interactor.searchCities(for: text)
    }
}

extension WeatherForecastViewController: CitySearchResultsViewControllerDelegate {
    func citySearchResultsViewControllerDidSelect(city: CityPresentationModel) {
        searchController.dismiss(animated: true)
        loadForecast(for: city)
    }
}
