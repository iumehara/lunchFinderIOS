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
    
    func create(newRestaurant: NewRestaurant) -> Future<Int, NSError> {
        let promise = Promise<Int, NSError>()
        
        var request = URLRequest(url: URL(string: "\(baseURL)restaurants/")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpBody = try! JSONSerialization.data(withJSONObject: newRestaurant.dictionary(), options: [])
        
        session.dataTask(
            with: request,
            completionHandler: {(data: Data?, response: URLResponse?, error: Error?) in
                self.intCompletionHandler(data: data, response: response, error: error, promise: promise)
        }
            ).resume()
        
        return promise.future
    }
    
    private func objectCompletionHandler(data: Data?, response: URLResponse?, error: Error?, promise: Promise<Restaurant, NSError>) {
        guard let nonNilData = data else {
            return promise.failure(NSError(domain: "urlSession_handler", code: 0, userInfo: nil))
        }
        
        guard let dictionary = try? JSONSerialization.jsonObject(with: nonNilData, options: []) as! [String: AnyObject] else {
            return promise.failure(NSError(domain: "urlSession_handler", code: 0, userInfo: nil))
        }
        
        guard let restaurant = Restaurant(dictionary: dictionary) else {
            return promise.failure(NSError(domain: "urlSession_handler", code: 0, userInfo: nil))
        }
        
        return promise.success(restaurant)
    }
    
    private func intCompletionHandler(data: Data?, response: URLResponse?, error: Error?, promise: Promise<Int, NSError>) {
        if error != nil {
            return promise.failure(NSError(domain: error.debugDescription, code: 0, userInfo: nil))
        }
        
        guard let nonNullData = data else {
            return promise.failure(NSError(domain: "completionHandler_dataIsNull", code: 0, userInfo: nil))
        }
        
        guard let int = try? JSONSerialization.jsonObject(with: nonNullData, options: .allowFragments) as! Int else {
            return promise.failure(NSError(domain: "completionHandler_dataCannotBeDeserializedToInt", code: 0, userInfo: nil))
        }
        
        return promise.success(int)
    }
}
