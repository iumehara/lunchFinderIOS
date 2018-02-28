import Foundation
@testable import lunchFinderIOS

struct MockURLSessionProvider: URLSessionProvider {
    var baseURL = "http://testURL/"

    var urlSession = MockSession() as URLSession

    func getRequest(path: String) -> URLRequest? {
        var request = URLRequest(url: URL(string: "\(baseURL)\(path)")!)
        request.httpMethod = "GET"
        return request
    }

    func postRequest(path: String, body: Data) -> URLRequest? {
        var request = URLRequest(url: URL(string: "\(baseURL)\(path)")!)
        request.httpMethod = "POST"
        request.httpBody = body
        return request
    }

    func putRequest(path: String, body: Data) -> URLRequest? {
        var request = URLRequest(url: URL(string: "\(baseURL)\(path)")!)
        request.httpMethod = "PUT"
        request.httpBody = body
        return request
    }
}
