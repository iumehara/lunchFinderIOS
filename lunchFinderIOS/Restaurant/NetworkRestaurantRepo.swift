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
            completionHandler: { (data, response, error) in
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
        guard let httpBody = try? JSONEncoder().encode(newRestaurant) else {
            promise.failure(NSError(domain: "could not encode restaurant", code: 0, userInfo: nil))
            return promise.future
        }
        request.httpBody = httpBody
        
        session.dataTask(
            with: request,
            completionHandler: { (data, response, error) in
                self.intCompletionHandler(data: data, response: response, error: error, promise: promise)
            }
        ).resume()
        
        return promise.future
    }
    
    func update(id: Int, newRestaurant: NewRestaurant) -> Future<Void, NSError> {
        let promise = Promise<Void, NSError>()
        
        var request = URLRequest(url: URL(string: "\(baseURL)restaurants/\(id)")!)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        guard let httpBody = try? JSONEncoder().encode(newRestaurant) else {
            promise.failure(NSError(domain: "could not encode restaurant", code: 0, userInfo: nil))
            return promise.future
        }
        request.httpBody = httpBody
        
        session.dataTask(
            with: request,
            completionHandler: { (data, response, error) in
                self.voidCompletionHandler(data: data, response: response, error: error, promise: promise)
            }
        ).resume()
        
        return promise.future
    }
    
    private func objectCompletionHandler(data: Data?, response: URLResponse?, error: Error?, promise: Promise<Restaurant, NSError>) {
        if error != nil {
            return promise.failure(NSError(domain: error.debugDescription, code: 0, userInfo: nil))
        }

        guard let nonNilData = data else {
            return promise.failure(NSError(domain: "urlSession_handler", code: 0, userInfo: nil))
        }
        
        guard let restaurant = try? JSONDecoder().decode(Restaurant.self, from: nonNilData) else {
            return promise.failure(NSError(domain: "urlSession_handler", code: 0, userInfo: nil))
        }

        return promise.success(restaurant)
    }
    
    private func intCompletionHandler(data: Data?, response: URLResponse?, error: Error?, promise: Promise<Int, NSError>) {
        if error != nil {
            return promise.failure(NSError(domain: error.debugDescription, code: 0, userInfo: nil))
        }
        
        guard let nonNilData = data else {
            return promise.failure(NSError(domain: "completionHandler_dataIsNull", code: 0, userInfo: nil))
        }
        
        guard let int = try? JSONDecoder().decode(Int.self, from: nonNilData) else {
            return promise.failure(NSError(domain: "completionHandler_dataCannotBeDeserializedToInt", code: 0, userInfo: nil))
        }
        
        return promise.success(int)
    }
    
    private func voidCompletionHandler(data: Data?, response: URLResponse?, error: Error?, promise: Promise<Void, NSError>) {
        if error != nil {
            return promise.failure(NSError(domain: error.debugDescription, code: 0, userInfo: nil))
        }
        
        guard let httpResponse = response as? HTTPURLResponse else {
            return promise.failure(NSError(domain: "completionHandler_responseIsNotValid", code: 0, userInfo: nil))
        }
        
        guard httpResponse.statusCode == 200 else {
            return promise.failure(NSError(domain: "completionHandler_dataCannotBeDeserializedToInt", code: 0, userInfo: nil))
        }
        
        return promise.success(())
    }
}
