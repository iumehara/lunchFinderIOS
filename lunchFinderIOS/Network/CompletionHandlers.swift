import Foundation
import BrightFutures

struct CompletionHandlers {
    static func responsePreFilter(data: Data?, response: URLResponse?, error: Error?) -> Data? {
        if error != nil {
            return nil
        }

        guard let httpResponse = response as? HTTPURLResponse else {
            return nil
        }

        guard httpResponse.statusCode < 300 else {
            return nil
        }

        guard let nonNilData = data else {
            return nil
        }

        return nonNilData
    }

    static func intCompletionHandler(data: Data?, response: URLResponse?, error: Error?, promise: Promise<Int, NSError>) {
        guard let nonNilData = responsePreFilter(data: data, response: response, error: error) else {
            return promise.failure(NSError(domain: "completionHandler_responsePreFilterFailed", code: 0, userInfo: nil))
        }

        guard let intDictionary = try? JSONDecoder().decode([String: Int].self, from: nonNilData) else {
            return promise.failure(NSError(domain: "completionHandler_dataCannotBeDeserializedToInt", code: 0, userInfo: nil))
        }

        guard let int = intDictionary["id"] else {
            return promise.failure(NSError(domain: "completionHandler_responseDoesNotIncludeId", code: 0, userInfo: nil))
        }

        return promise.success(int)
    }

    static func voidCompletionHandler(data: Data?, response: URLResponse?, error: Error?, promise: Promise<Void, NSError>) {
        guard let _ = responsePreFilter(data: data, response: response, error: error) else {
            return promise.failure(NSError(domain: "completionHandler_responsePreFilterFailed", code: 0, userInfo: nil))
        }

        return promise.success(())
    }
}
