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
        if error != nil {
            return promise.failure(NSError(domain: error.debugDescription, code: 0, userInfo: nil))
        }
        
        guard let nonNulldata = data else {
            return promise.failure(NSError(domain: "completionHandler_dataIsNull", code: 0, userInfo: nil))
        }
        
        guard let dictionaryArray = try? JSONSerialization.jsonObject(with: nonNulldata, options: []) as! [[String: AnyObject]] else {
            return promise.failure(NSError(domain: "completionHandler_dataCannotBeDeserializedToDictionayArray", code: 0, userInfo: nil))
        }
        
        var categories = [Category]()
        for dictionary in dictionaryArray {
            guard let category = Category(dictionary: dictionary) else {
                return promise.failure(NSError(domain: "completionHandler_jsonCannotInitializeCategory", code: 0, userInfo: nil))
            }
            categories.append(category)
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
        
        guard let dictionary = try? JSONSerialization.jsonObject(with: nonNullData, options: []) as! [String: AnyObject] else {
            return promise.failure(NSError(domain: "completionHandler_dataCannotBeDeserializedToDictionary", code: 0, userInfo: nil))
        }
        
        guard let category = Category(dictionary: dictionary) else {
            return promise.failure(NSError(domain: "completionHandler_jsonCannotInitializeCategory", code: 0, userInfo: nil))
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
        
        guard let int = try? JSONSerialization.jsonObject(with: nonNullData, options: .allowFragments) as! Int else {
            return promise.failure(NSError(domain: "completionHandler_dataCannotBeDeserializedToInt", code: 0, userInfo: nil))
        }

        return promise.success(int)
    }
}
