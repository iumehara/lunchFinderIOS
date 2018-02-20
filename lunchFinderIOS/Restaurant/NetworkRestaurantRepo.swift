import Foundation
import BrightFutures

class NetworkRestaurantRepo: RestaurantRepo {
    var session: URLSession
    var baseURL: String

    init(urlSessionProvider: URLSessionProvider) {
        self.session = urlSessionProvider.urlSession
        self.baseURL = urlSessionProvider.baseURL
    }
    
    func get(id: Int) -> Future<Restaurant, NSError> {
        let promise = Promise<Restaurant, NSError>()
        
        session.dataTask(
            with: URL(string: "\(baseURL)restaurants/\(id)")!,
            completionHandler: {(data: Data?, response: URLResponse?, error: Error?) in
                self.objectCompletionHandler(data: data, response: response, error: error, promise: promise)
            }
        ).resume()
        
        return promise.future
    }
    
    private func objectCompletionHandler(data: Data?, response: URLResponse?, error: Error?, promise: Promise<Restaurant, NSError>) {
        if let actualData = data {
            guard let dictionary = try? JSONSerialization.jsonObject(with: actualData, options: []) as! NSDictionary else {
                return promise.failure(NSError(domain: "urlSession_handler", code: 0, userInfo: nil))
            }
            
            let restaurant = Restaurant(dictionary: dictionary as! [String: AnyObject])
            return promise.success(restaurant)
        }
        
        return promise.failure(NSError(domain: "urlSession_handler", code: 0, userInfo: nil))
    }
}
