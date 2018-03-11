import Foundation
import BrightFutures

class NetworkRestaurantRepo: RestaurantRepo {
    var urlSessionProvider: URLSessionProvider
    var session: URLSession

    init(urlSessionProvider: URLSessionProvider) {
        self.urlSessionProvider = urlSessionProvider
        self.session = urlSessionProvider.urlSession
    }

    func getAll() -> Future<[BasicRestaurant], NSError> {
        let promise = Promise<[BasicRestaurant], NSError>()

        guard let urlRequest = urlSessionProvider.getRequest(path: "restaurants/") else {
            promise.failure(NSError(domain: "could not generate urlRequest", code: 0, userInfo: nil))
            return promise.future
        }

        session.dataTask(
                with: urlRequest,
                completionHandler: { (data, response, error) in
                    self.restaurantListCompletionHandler(data: data, response: response, error: error, promise: promise)
                }
        ).resume()

        return promise.future
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
                self.restaurantCompletionHandler(data: data, response: response, error: error, promise: promise)
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
                CompletionHandlers.intCompletionHandler(data: data, response: response, error: error, promise: promise)
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
                CompletionHandlers.voidCompletionHandler(data: data, response: response, error: error, promise: promise)
            }
        ).resume()
        
        return promise.future
    }
    
    func removeCategory(id: Int, categoryId: Int) -> Future<Void, NSError> {
        let promise = Promise<Void, NSError>()
        
        guard let urlRequest = urlSessionProvider.deleteRequest(path: "restaurants/\(id)/categories/\(categoryId)") else {
            promise.failure(NSError(domain: "could not generate urlRequest", code: 0, userInfo: nil))
            return promise.future
        }
        
        session.dataTask(
            with: urlRequest,
            completionHandler: { (data, response, error) in
                CompletionHandlers.voidCompletionHandler(data: data, response: response, error: error, promise: promise)
            }
        ).resume()
        
        return promise.future
    }
    
    func delete(id: Int) -> Future<Void, NSError> {
        let promise = Promise<Void, NSError>()

        guard let urlRequest = urlSessionProvider.deleteRequest(path: "restaurants/\(id)") else {
            promise.failure(NSError(domain: "could not generate urlRequest", code: 0, userInfo: nil))
            return promise.future
        }

        session.dataTask(
            with: urlRequest,
            completionHandler: { (data, response, error) in
                    CompletionHandlers.voidCompletionHandler(data: data, response: response, error: error, promise: promise)
            }
        ).resume()
        
        return promise.future
    }

    private func restaurantListCompletionHandler(data: Data?, response: URLResponse?, error: Error?, promise: Promise<[BasicRestaurant], NSError>) {
        guard let nonNilData = CompletionHandlers.responsePreFilter(data: data, response: response, error: error) else {
            return promise.failure(NSError(domain: "completionHandler_responsePreFilterFailed", code: 0, userInfo: nil))
        }

        guard let restaurants = try? JSONDecoder().decode([BasicRestaurant].self, from: nonNilData) else {
            return promise.failure(NSError(domain: "urlSession_handler", code: 0, userInfo: nil))
        }

        return promise.success(restaurants)
    }
    
    private func restaurantCompletionHandler(data: Data?, response: URLResponse?, error: Error?, promise: Promise<Restaurant, NSError>) {
        guard let nonNilData = CompletionHandlers.responsePreFilter(data: data, response: response, error: error) else {
            return promise.failure(NSError(domain: "completionHandler_responsePreFilterFailed", code: 0, userInfo: nil))
        }

        guard let restaurant = try? JSONDecoder().decode(Restaurant.self, from: nonNilData) else {
            return promise.failure(NSError(domain: "urlSession_handler", code: 0, userInfo: nil))
        }

        return promise.success(restaurant)
    }
}
