import Foundation

final class APIKeysWorker {
    
    // Project has to have APIKeys.plist file to properly build and load keys.
    // Plist file is not pushed to repository to avoid exposing keys to public.
    
    private static let keys: NSDictionary = {
        let path = Bundle.main.path(forResource: "APIKeys", ofType: "plist")!
        return NSDictionary(contentsOfFile: path)!
    }()
    
    static var openWeatherAPIKey: String {
        return keys["OpenWeather"] as! String
    }
}
