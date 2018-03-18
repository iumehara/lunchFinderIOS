import Foundation
import BrightFutures

class NetworkCategoryRepo: CategoryRepo {
    var urlSessionProvider: URLSessionProvider
    var session: URLSession
    
    init(urlSessionProvider: URLSessionProvider) {
        self.urlSessionProvider = urlSessionProvider
        self.session = urlSessionProvider.urlSession
    }
    
    func getAll() -> Future<[BasicCategory], NSError> {
        let promise = Promise<[BasicCategory], NSError>()

        guard let urlRequest = urlSessionProvider.getRequest(path: "categories/") else {
            promise.failure(NSError(domain: "could not generate urlRequest", code: 0, userInfo: nil))
            return promise.future
        }

        session.dataTask(
            with: urlRequest,
            completionHandler: { (data, response, error) in
                self.categoryListCompletionHandler(data: data, response: response, error: error, promise: promise)
            }
        ).resume()

        return promise.future
    }
    
    func get(id: Int) -> Future<Category, NSError> {
        let promise = Promise<Category, NSError>()

        guard let urlRequest = urlSessionProvider.getRequest(path: "categories/\(id)") else {
            promise.failure(NSError(domain: "could not generate urlRequest", code: 0, userInfo: nil))
            return promise.future
        }

        session.dataTask(
            with: urlRequest,
            completionHandler: { (data, response, error) in
                self.categoryCompletionHandler(data: data, response: response, error: error, promise: promise)
            }
        ).resume()

        return promise.future
    }

    func create(newCategory: NewCategory) -> Future<Int, NSError> {
        let promise = Promise<Int, NSError>()
        
        guard let httpBody = try? JSONEncoder().encode(newCategory) else {
            promise.failure(NSError(domain: "could not encode category", code: 0, userInfo: nil))
            return promise.future
        }

        guard let urlRequest = urlSessionProvider.postRequest(path: "categories/", body: httpBody) else {
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
    
    func update(id: Int, newCategory: NewCategory) -> Future<Void, NSError> {
        let promise = Promise<Void, NSError>()
        
        guard let httpBody = try? JSONEncoder().encode(newCategory) else {
            promise.failure(NSError(domain: "could not encode category", code: 0, userInfo: nil))
            return promise.future
        }
        
        guard let urlRequest = urlSessionProvider.putRequest(path: "categories/\(id)", body: httpBody) else {
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

    func removeRestaurant(id: Int, restaurantId: Int) -> Future<Void, NSError> {
        let promise = Promise<Void, NSError>()
        
        guard let urlRequest = urlSessionProvider.deleteRequest(path: "categories/\(id)/restaurants/\(restaurantId)") else {
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

        guard let urlRequest = urlSessionProvider.deleteRequest(path: "categories/\(id)/") else {
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
    
    private func categoryListCompletionHandler(data: Data?, response: URLResponse?, error: Error?, promise: Promise<[BasicCategory], NSError>) {
        guard let nonNilData = CompletionHandlers.responsePreFilter(data: data, response: response, error: error) else {
            return promise.failure(NSError(domain: "completionHandler_responsePreFilterFailed", code: 0, userInfo: nil))
        }
        
        guard let categories = try? JSONDecoder().decode([BasicCategory].self, from: nonNilData) else {
            return promise.failure(NSError(domain: "completionHandler_dataCannotBeDecoded", code: 0, userInfo: nil))
        }

        return promise.success(categories)
    }

    private func categoryCompletionHandler(data: Data?, response: URLResponse?, error: Error?, promise: Promise<Category, NSError>) {
        guard let nonNilData = CompletionHandlers.responsePreFilter(data: data, response: response, error: error) else {
            return promise.failure(NSError(domain: "completionHandler_responsePreFilterFailed", code: 0, userInfo: nil))
        }

        guard let category = try? JSONDecoder().decode(Category.self, from: nonNilData) else {
            return promise.failure(NSError(domain: "completionHandler_dataCannotBeDecoded", code: 0, userInfo: nil))
        }

        return promise.success(category)
    }
}
