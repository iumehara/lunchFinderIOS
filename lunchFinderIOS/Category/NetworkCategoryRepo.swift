import Foundation
import BrightFutures

class NetworkCategoryRepo: CategoryRepo {
    var session: URLSession
    var baseURL: String
    
    init(urlSessionProvider: URLSessionProvider) {
        self.session = urlSessionProvider.urlSession
        self.baseURL = urlSessionProvider.baseURL
    }
    
    func getAll() -> Future<[Category], NSError> {
        let promise = Promise<[Category], NSError>()

        session.dataTask(
            with: URL(string: "\(baseURL)categories")!,
            completionHandler: {(data: Data?, response: URLResponse?, error: Error?) in
                self.arrayCompletionHandler(data: data, response: response, error: error, promise: promise)
            }
        ).resume()

        return promise.future
    }
    
    func get(id: Int) -> Future<Category, NSError> {
        let promise = Promise<Category, NSError>()
        
        session.dataTask(
            with: URL(string: "\(baseURL)categories/\(id)")!,
            completionHandler: {(data: Data?, response: URLResponse?, error: Error?) in
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
        request.httpBody = try! JSONSerialization.data(withJSONObject: newCategory.dictionary(), options: [])
        
        session.dataTask(
            with: request,
            completionHandler: {(data: Data?, response: URLResponse?, error: Error?) in
                self.intCompletionHandler(data: data, response: response, error: error, promise: promise)
            }
        ).resume()
        
        return promise.future
    }
    
    private func arrayCompletionHandler(data: Data?, response: URLResponse?, error: Error?, promise: Promise<[Category], NSError>) {
        if let actualData = data {
            guard let dictionaryArray = try? JSONSerialization.jsonObject(with: actualData, options: []) as! [NSDictionary] else {
                return promise.failure(NSError(domain: "urlSession_handler", code: 0, userInfo: nil))
            }
            
            var categories = [Category]()
            for dictionary: NSDictionary in dictionaryArray {
                let category = Category(dictionary: dictionary as! [String: AnyObject])
                categories.append(category)
            }
            
            return promise.success(categories)
        }
        
        return promise.failure(NSError(domain: "urlSession_handler", code: 0, userInfo: nil))
    }
    
    private func objectCompletionHandler(data: Data?, response: URLResponse?, error: Error?, promise: Promise<Category, NSError>) {
        if let actualData = data {
            guard let dictionary = try? JSONSerialization.jsonObject(with: actualData, options: []) as! NSDictionary else {
                return promise.failure(NSError(domain: "urlSession_handler", code: 0, userInfo: nil))
            }
            
            let category = Category(dictionary: dictionary as! [String: AnyObject])
            return promise.success(category)
        }
        
        return promise.failure(NSError(domain: "urlSession_handler", code: 0, userInfo: nil))
    }
    
    private func intCompletionHandler(data: Data?, response: URLResponse?, error: Error?, promise: Promise<Int, NSError>) {
        guard let nonNullData = data else {
            return promise.failure(NSError(domain: "intCompletionHandler_dataIsNull", code: 0, userInfo: nil))
        }
        
        guard let categoryId = try? JSONSerialization.jsonObject(with: nonNullData, options: .allowFragments) as! Int else {
            return promise.failure(NSError(domain: "intCompletionHandler_dataCannotBeDeserialized", code: 0, userInfo: nil))
        }

        return promise.success(categoryId)
    }
}
