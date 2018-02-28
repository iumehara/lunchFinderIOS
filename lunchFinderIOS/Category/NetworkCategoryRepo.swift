import Foundation
import BrightFutures

class NetworkCategoryRepo: CategoryRepo {
    var session: URLSession
    var baseURL: String
    
    init(urlSessionProvider: URLSessionProvider) {
        self.session = urlSessionProvider.urlSession
        self.baseURL = urlSessionProvider.baseURL
    }
    
    func getAll() -> Future<[BasicCategory], NSError> {
        let promise = Promise<[BasicCategory], NSError>()
        
        session.dataTask(
            with: URL(string: "\(baseURL)categories")!,
            completionHandler: { (data, response, error) in
                self.arrayCompletionHandler(data: data, response: response, error: error, promise: promise)
            }
        ).resume()

        return promise.future
    }
    
    func get(id: Int) -> Future<Category, NSError> {
        let promise = Promise<Category, NSError>()
        
        session.dataTask(
            with: URL(string: "\(baseURL)categories/\(id)")!,
            completionHandler: { (data, response, error) in
                self.objectCompletionHandler(data: data, response: response, error: error, promise: promise)
            }
        ).resume()

        return promise.future
    }
    
    func create(newCategory: NewCategory) -> Future<Int, NSError> {
        let promise = Promise<Int, NSError>()
        
        var request = URLRequest(url: URL(string: "\(baseURL)categories/")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        guard let httpBody = try? JSONEncoder().encode(newCategory) else {
            promise.failure(NSError(domain: "could not encode category", code: 0, userInfo: nil))
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
    
    private func arrayCompletionHandler(data: Data?, response: URLResponse?, error: Error?, promise: Promise<[BasicCategory], NSError>) {
        if error != nil {
            return promise.failure(NSError(domain: error.debugDescription, code: 0, userInfo: nil))
        }
        
        guard let nonNullData = data else {
            return promise.failure(NSError(domain: "completionHandler_dataIsNull", code: 0, userInfo: nil))
        }
        
        guard let categories = try? JSONDecoder().decode([BasicCategory].self, from: nonNullData) else {
            return promise.failure(NSError(domain: "completionHandler_dataCannotBeDecoded", code: 0, userInfo: nil))
        }

        return promise.success(categories)
    }

    private func objectCompletionHandler(data: Data?, response: URLResponse?, error: Error?, promise: Promise<Category, NSError>) {
        if error != nil {
            return promise.failure(NSError(domain: error.debugDescription, code: 0, userInfo: nil))
        }
        
        guard let nonNullData = data else {
            return promise.failure(NSError(domain: "completionHandler_dataIsNull", code: 0, userInfo: nil))
        }

        guard let category = try? JSONDecoder().decode(Category.self, from: nonNullData) else {
            return promise.failure(NSError(domain: "completionHandler_dataCannotBeDecoded", code: 0, userInfo: nil))
        }

        return promise.success(category)
    }
    
    private func intCompletionHandler(data: Data?, response: URLResponse?, error: Error?, promise: Promise<Int, NSError>) {
        if error != nil {
            return promise.failure(NSError(domain: error.debugDescription, code: 0, userInfo: nil))
        }
        
        guard let nonNullData = data else {
            return promise.failure(NSError(domain: "completionHandler_dataIsNull", code: 0, userInfo: nil))
        }

        guard let int = try? JSONDecoder().decode(Int.self, from: nonNullData) else {
            return promise.failure(NSError(domain: "completionHandler_dataCannotBeDeserializedToInt", code: 0, userInfo: nil))
        }

        return promise.success(int)
    }
}
