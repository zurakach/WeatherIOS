import UIKit


@MainActor protocol WeatherForecastDetailsViewModel {
    func attach(view: WeatherForecastDetailsView)
    func configure(with model: WeatherForecastPresentationLoadingStateModel)
}

@MainActor class ProdWeatherForecastDetailsViewModel {
    private let dependencies: WeatherDependencies
    private var view: WeatherForecastDetailsView?
    private var imageDownloadTask: Task<Void, Never>?
    
    init(dependencies: WeatherDependencies) {
        self.dependencies = dependencies
    }
    
    private func loadImage(with imageUrl: URL) {
        // TODO: Set placeholder image while downloading real one
        imageDownloadTask = Task { [weak self] in
            guard let image = try? await self?.dependencies.imageRepository.loadImage(url: imageUrl) else {
                // TODO: handle image error, maybe set some other image.
                return
            }
            if !Task.isCancelled {
                self?.view?.configureWeatherIcon(with: image)
            }
        }
    }
}

extension ProdWeatherForecastDetailsViewModel: WeatherForecastDetailsViewModel {
    func attach(view: WeatherForecastDetailsView) {
        self.view = view
    }
    
    func configure(with model: WeatherForecastPresentationLoadingStateModel) {
        view?.configure(with: model)
        // TODO: Check if current tasks is downloading same image so we don't cancel unnecessarily.
        imageDownloadTask?.cancel()
        
        switch model {
        case .inProgress, .failed(_):
            break
        case .finished(let model):
            self.loadImage(with: model.imageUrl)
        }
    }
}

