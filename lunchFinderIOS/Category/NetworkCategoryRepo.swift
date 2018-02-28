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
                self.arrayCompletionHandler(data: data, response: response, error: error, promise: promise)
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
                self.objectCompletionHandler(data: data, response: response, error: error, promise: promise)
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
                self.intCompletionHandler(data: data, response: response, error: error, promise: promise)
            }
        ).resume()
        
        return promise.future
    }
    
    private func arrayCompletionHandler(data: Data?, response: URLResponse?, error: Error?, promise: Promise<[BasicCategory], NSError>) {
        if error != nil {
            return promise.failure(NSError(domain: error.debugDescription, code: 0, userInfo: nil))
        }
        
        guard let nonNilData = data else {
            return promise.failure(NSError(domain: "completionHandler_dataIsNull", code: 0, userInfo: nil))
        }
        
        guard let categories = try? JSONDecoder().decode([BasicCategory].self, from: nonNilData) else {
            return promise.failure(NSError(domain: "completionHandler_dataCannotBeDecoded", code: 0, userInfo: nil))
        }

        return promise.success(categories)
    }

    private func objectCompletionHandler(data: Data?, response: URLResponse?, error: Error?, promise: Promise<Category, NSError>) {
        if error != nil {
            return promise.failure(NSError(domain: error.debugDescription, code: 0, userInfo: nil))
        }
        
        guard let nonNilData = data else {
            return promise.failure(NSError(domain: "completionHandler_dataIsNull", code: 0, userInfo: nil))
        }

        guard let category = try? JSONDecoder().decode(Category.self, from: nonNilData) else {
            return promise.failure(NSError(domain: "completionHandler_dataCannotBeDecoded", code: 0, userInfo: nil))
        }

        return promise.success(category)
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
}
