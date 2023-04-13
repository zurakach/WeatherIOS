import UIKit

@MainActor final class WeatherRouter: WeatherRouting {
    private var dependencies: WeatherDependencies
    
    private lazy var initialVC: UINavigationController = {
        let rootVC = makeWeatherForecastScene()
        let navVC = UINavigationController(rootViewController: rootVC)
        return navVC
    }()
    
    var initialViewController: UIViewController {
        initialVC
    }
    
    init(with dependencies: WeatherDependencies) {
        self.dependencies = dependencies
    }
    
    func makeWeatherForecastScene() -> WeatherForecastViewController {
        let presenter = WeatherForecastPresenter()
        let interactor = WeatherForecastInteractor(dependencies: dependencies, presenter: presenter)
        let viewController = WeatherForecastViewController(dependencyContainer: dependencies,
                                                           router: self,
                                                           interactor: interactor)
        presenter.attach(viewController: viewController)
        return viewController
    }
    
    func makeWeatherForecastDetailsViewModel() -> WeatherForecastDetailsViewModel {
        return ProdWeatherForecastDetailsViewModel(dependencies: dependencies)
    }
    
    func makeCitySearchResultsViewController() -> CitySearchResultsViewController {
        return CitySearchResultsViewController(style: .plain)
    }
    
    func displayError(title: String, message: String, retryAction: (()->Void)?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        // TODO: Localization
        if let retryAction {
            alert.addAction(UIAlertAction(title: "Retry", style: .default) { _ in
                retryAction()
            })
        }
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        initialVC.topViewController?.present(alert, animated: false)
    }
}
