import Foundation
import UIKit

// TODO: Maybe separate file for this one.
protocol WeatherForecastDetailsView {
    func configure(with state: WeatherForecastPresentationLoadingStateModel)
    func configureWeatherIcon(with image: UIImage)
}


class WeatherForecastDetailsUIKitView: UIView {
    
    // MARK: Properties
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var temperatureLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 40, weight: .bold)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    private lazy var weatherDescriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    private lazy var weatherIconImageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        indicator.color = .blue
        return indicator
    }()
    
    
    // MARK: Methods
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let tempAndIconStackView = UIStackView(arrangedSubviews: [temperatureLabel, weatherIconImageView])
        tempAndIconStackView.distribution = .fillEqually
        let spacer = UIView()
        spacer.translatesAutoresizingMaskIntoConstraints = false
        
        let stackView = UIStackView(arrangedSubviews: [nameLabel,
                                                       weatherDescriptionLabel,
                                                       tempAndIconStackView,
                                                       spacer])
        stackView.axis = .vertical
        addSubview(stackView)
        // TODO: Make this code reusable
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: stackView.topAnchor),
            leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            bottomAnchor.constraint(equalTo: stackView.bottomAnchor)
        ])
        
        addSubview(loadingIndicator)
        NSLayoutConstraint.activate([
            self.centerXAnchor.constraint(equalTo: loadingIndicator.centerXAnchor),
            self.centerYAnchor.constraint(equalTo: loadingIndicator.centerYAnchor),
        ])
        
    }
    
    @available(*, unavailable, message: "init(coder:) not suppoerted")
    required init(coder: NSCoder) {
        fatalError("init(coder:) not suppoerted")
    }
    
    private func setLoadingState(_ isLoading: Bool) {
        self.nameLabel.isHidden = isLoading
        self.temperatureLabel.isHidden = isLoading
        self.weatherDescriptionLabel.isHidden = isLoading
        self.weatherIconImageView.isHidden = isLoading
        if isLoading {
            loadingIndicator.startAnimating()
        } else {
            loadingIndicator.stopAnimating()
        }
    }
}

extension WeatherForecastDetailsUIKitView: WeatherForecastDetailsView {
    func configure(with state: WeatherForecastPresentationLoadingStateModel) {
        switch state {
        case .inProgress:
            setLoadingState(true)
        case .finished(let forecast):
            setLoadingState(false)
            nameLabel.text = forecast.locationName
            temperatureLabel.text = forecast.temperature
            weatherDescriptionLabel.text = forecast.weatherDescription
            weatherIconImageView.image = nil
        case .failed(let error):
            setLoadingState(false)
            // TODO: Instead of reusing name label, we could have another label for displaying errors
            nameLabel.text = error.localizedDescription
            temperatureLabel.text = nil
            weatherDescriptionLabel.text = nil
            weatherIconImageView.image = nil
        }
    }
    
    func configureWeatherIcon(with image: UIImage) {
        weatherIconImageView.image = image
    }
    
    
    
}
