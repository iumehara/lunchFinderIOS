import Foundation
import BrightFutures

class NetworkRestaurantRepo: RestaurantRepo {
    var urlSessionProvider: URLSessionProvider
    var session: URLSession

    init(urlSessionProvider: URLSessionProvider) {
        self.urlSessionProvider = urlSessionProvider
        self.session = urlSessionProvider.urlSession
    }
    
    func get(id: Int) -> Future<Restaurant, NSError> {
        let promise = Promise<Restaurant, NSError>()

        guard let urlRequest = urlSessionProvider.getRequest(path: "restaurants/\(id)") else {
            promise.failure(NSError(domain: "could not generate urlRequest", code: 0, userInfo: nil))
            return promise.future
        }

        session.dataTask(
            with: urlRequest,
            completionHandler: { (data, response, error) in
                self.objectCompletionHandler(data: data, response: response, error: error, promise: promise)
            }
        ).resume()
        
        return promise.future
    }
    
    func create(newRestaurant: NewRestaurant) -> Future<Int, NSError> {
        let promise = Promise<Int, NSError>()
        
        guard let httpBody = try? JSONEncoder().encode(newRestaurant) else {
            promise.failure(NSError(domain: "could not encode restaurant", code: 0, userInfo: nil))
            return promise.future
        }

        guard let urlRequest = urlSessionProvider.postRequest(path: "restaurants/", body: httpBody) else {
            promise.failure(NSError(domain: "could not generate urlRequest", code: 0, userInfo: nil))
            return promise.future
        }

        session.dataTask(
            with: urlRequest,
            completionHandler: { (data, response, error) in
                self.intCompletionHandler(data: data, response: response, error: error, promise: promise)
            }
        ).resume()
        
        return promise.future
    }
    
    func update(id: Int, newRestaurant: NewRestaurant) -> Future<Void, NSError> {
        let promise = Promise<Void, NSError>()

        guard let httpBody = try? JSONEncoder().encode(newRestaurant) else {
            promise.failure(NSError(domain: "could not encode restaurant", code: 0, userInfo: nil))
            return promise.future
        }

        guard let urlRequest = urlSessionProvider.putRequest(path: "restaurants/\(id)", body: httpBody) else {
            promise.failure(NSError(domain: "could not generate urlRequest", code: 0, userInfo: nil))
            return promise.future
        }
        
        session.dataTask(
            with: urlRequest,
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
        
        guard let intDictionary = try? JSONDecoder().decode([String: Int].self, from: nonNilData) else {
            return promise.failure(NSError(domain: "completionHandler_dataCannotBeDeserializedToInt", code: 0, userInfo: nil))
        }

        guard let int = intDictionary["id"] else {
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
