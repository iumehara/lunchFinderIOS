import Foundation
import BrightFutures

class NetworkCategoryRepo: CategoryRepo {
    func getAll() -> Future<[Category], NSError> {
        let promise = Promise<[Category], NSError>()

        URLSession.shared.dataTask(
            with: URL(string: "http://localhost:8080/categories")!,
            completionHandler: {(data: Data?, response: URLResponse?, error: Error?) in
                self.completionHandler(data: data, response: response, error: error, promise: promise)
            }
        ).resume()

        return promise.future
    }
    
    private func completionHandler(data: Data?, response: URLResponse?, error: Error?, promise: Promise<[Category], NSError>) {
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
}
