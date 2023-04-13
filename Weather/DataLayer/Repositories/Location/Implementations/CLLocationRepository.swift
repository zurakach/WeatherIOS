import Foundation
import CoreLocation

final class CLLocationRepository: NSObject {
    
    private let manager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        return manager
    }()
    private var continuation: CheckedContinuation<LocationModel, Error>?
    
    override init() {
        super.init()
        manager.delegate = self
    }
}
 
extension CLLocationRepository: LocationRepository {
    func requestLocation() async throws -> LocationModel {
        manager.requestWhenInUseAuthorization()
        return try await withCheckedThrowingContinuation({ [weak self] continuation in
            self?.manager.requestLocation()
            self?.continuation = continuation
        })
    }
}

extension CLLocationRepository: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first?.coordinate else {
            continuation?.resume(throwing: LocationRepositoryError.unableToGetLocation)
            return
        }
        continuation?.resume(returning: LocationModel(latitude: location.latitude, longitude: location.longitude))
        continuation = nil
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        continuation?.resume(throwing: error)
        continuation = nil
    }
}
 
